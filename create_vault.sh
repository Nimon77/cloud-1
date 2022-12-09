#!/bin/bash
# This script creates an ansible-vault file in the current directory.

echo "Creating ansible-vault in current directory..."
echo -n "Enter password for ansible-vault: "
read -s password
echo ""
echo -n "Enter password again: "
read -s password2
echo ""

if [ "$password" != "$password2" ]; then
	echo "Passwords do not match!"
	exit 1
fi


echo -n "Enter database_password: "
read -s database_password
echo ""

echo -n "Enter wordpress_admin_password: "
read -s wordpress_admin_password
echo ""

echo "Creating vault file..."
cat << EOF > vault
---
vault_database_password: $database_password
vault_wordpress_admin_password: $wordpress_admin_password
EOF

echo "Encrypting vault file..."
ansible-vault encrypt vault --vault-password-file <(echo $password)

echo "Moving vault to group_vars directory..."
mv vault group_vars/

echo "Done!"