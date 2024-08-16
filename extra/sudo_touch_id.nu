
open /etc/pam.d/sudo | lines | insert 1 'auth sufficient pam_tid.so' | str join (char newline) | save -f sudo
sudo mv sudo /etc/pam.d/sudo
