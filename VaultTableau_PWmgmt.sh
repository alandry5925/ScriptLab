#!/bin/bash
# Author: Austin Landry
# Date: 10/20/21
# Name: VaultTableau_PWmgmt.sh
# Body
# Variables
set -e
vaultpw=/path/to/your/password.txt # or.sh for executable, Needs to be adjusted to fit in our Infra, can be set to a script to decrypt GPG and use key EG. gpg --batch --use-agent --descrypt vault_key.gpg
FILE=/path/to/tableau_vault.yml
passvar='vault_tableaupwd: '
genpass='mkpasswd -l 100 -d 15 -c 20 -C 20 -s 10'
# Check for existing Vault File
if [ -f "$FILE" ]; then
    echo "$FILE exists.";
    echo "Adding information to file";  # Content Generation
    echo -n $passvar > tableau_vault.yml;
    echo -n "$genpass" >> tableau_vault.yml;
    echo "tableau_vault.yml still requires encryption.";
    read -p "Continue (y/n)?" CONT
    if [ "$CONT" = "y" ]; then
      echo "Encrypting tableau_vault.yml";ansible-vault encrypt tableau_vault.yml --vault-password-file $vaultpw;   # Conversion to vault Encrypted file
    else
      echo "Exiting script";exit 1;
    fi;
else
    echo "$FILE does not exist.";exit 1;
fi;
