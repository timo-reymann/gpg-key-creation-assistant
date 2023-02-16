set -e
if ! command gpg --version > /dev/null
then
	show_error "No GPG installation found"
	exit 2
else
	show_success "Found GPG $(gpg --version | head -n1)"
fi

# Full name
validate_name() {
	if [ "${#1}" -lt 3 ]; then echo "Please provide at least 3 letters"; return 1; fi
	if [[ ! "$1" =~ " " ]]; then echo "Your first and last name must be delimited by space"; return 1; fi
}
full_name=$(with_validate 'input "Your first and last name seperated by space. If you have multiple names you can use them as well"' validate_name)

# Email
validate_email() {
	if [ "${#1}" -lt 4 ] ; then echo "Please provide a email address at least contains the user and domain part"; return 1;fi
	if ! [[ "${1}" =~ ^.{1,}@.{1,}$  ]]; then echo "Please provide an email address containg at least a host and user part"; return 1; fi
}
email=$(with_validate 'input "E-Mail address that the key will be associated with"' validate_email)

# Passphrase
validate_passphrase() {
	if [ "${#1}" -lt 8 ]; then echo "Passphrase needs to be at least 5 characters"; return 1; fi
}
passphrase=$(with_validate 'password "Please enter a passphrase for your GPG key, that will be required import/export the key"' validate_passphrase)

# Key size in bit
key_sizes=("8182 (high)" "4096 (medium)" "2048 (low)")
key_size=$(list "Bit size of your key, the more bytes you choose the longer it takes for GPG to perform operations, increasing security as well" "${key_sizes[@]}")
case $key_size in
	0) bit_size=8192; ;;
	1) bit_size=4096; ;;
	2) bit_size=2048; ;;
esac

# Expiration
expire=$(confirm "Should the key expire after 1 year?")
if [ "$expire" = "0"  ]; then
	expires_in=0
else
	expires_in=365
fi

spec=$(mktemp)
cat >"$spec" <<EOF
     %echo Generating your GPG key
     Key-Type: RSA
     Key-Length: ${bit_size}
     Subkey-Type: RSA
     Subkey-Length: ${bit_size}
     Name-Real: ${full_name}
     Name-Email: ${email}
     Expire-Date: ${expires_in}
     Passphrase: ${passphrase}
     %commit
     %echo Key generated
EOF
gpg --batch --generate-key --no-tty -q $spec
rm $spec

# get private keys
secret_keys_formatted=()
secret_keys_raw=()
for line in $(gpg --list-secret-keys --with-colons --fingerprint "${email}"); do
    IFS=":" read -a fields <<<"$line"

    # set fields required based on type
    case ${fields[0]} in
        sec)
            key="${fields[4]}";
            bits="${fields[2]}";
            ;;
        uid)
            created="${fields[5]}";
            ;;
    esac

    # ssb is the last entry per key we care about
    if [[ "${key}" != "${fields[4]}" ]] && [[ "${fields[0]}" == "ssb" ]]; then
        secret_keys_formatted+=("${key} (created on $(printf "%(%F %T)T" $created), ${bits} bit)")
        secret_keys_raw+=("${key}")
    fi
done

if [[ ${#secret_keys_raw[@]} -gt 1 ]]; then
    key_for_export_id=$(list "There were multiple keys found, please choose the one you want to use" "${secret_keys_formatted[@]}")
    key_for_export=${secret_keys_raw[${key_for_export_id}]}
else
    key_for_export=${secret_keys_raw[0]}
fi

gpg --output public.pgp --armor --export "${key_for_export}"
show_success "Exported public key to '${PWD}/public.gpg'"

gpg --output private.pgp --armor --pinentry-mode loopback --passphrase "${passphrase}" --export-secret-key "${key_for_export}"
show_success "Exported private key to '${PWD}/private.gpg'"

setup_git=$(confirm "Do you want to set up git to sign your commits?")
if [ "$setup_git" == "1" ]; then
    git config --global user.signingkey "${key_for_export}"
    git config --global commit.gpgsign true
    show_success "Git is now set up to autosign your commits"
    cat <<EOF
To make sure that the git hosters you are using now about your gpg key check the according documentations:
  - GitHub: https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
  - GitLab: https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/#add-a-gpg-key-to-your-account
EOF
fi

