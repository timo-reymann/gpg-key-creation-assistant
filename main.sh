#!/bin/bash
source bundle.bash

if ! command gpg --version > /dev/null
then
	show_error "No GPG installation found"
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
	expires_in=31622400
fi

spec=$(mktemp)
cat >"$spec" <<EOF
     %echo Generating your GPG key
     Key-Type: RSA
     Key-Length: ${bit_size}
     Subkey-Type: ELG-E
     Subkey-Length: ${bit_size}
     Name-Real: ${full_name}
     Name-Email: ${email}
     Expire-Date: ${expires_in}
     Passphrase: ${passphrase}
     %commit
     %echo Key generated
EOF
gpg --batch --generate-key $spec
rm $spec

# TODO Parse secret key list output and allow user selecting
# TODO Allow to export secret key
# TODO Allow to export public key
# TODO Provide instructions with y/n question(s) for GitHub + GitLab
# TODO Bundle lib


