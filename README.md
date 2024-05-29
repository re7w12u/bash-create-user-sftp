# bash-create-user-sftp
bash script to set up new account for sftp with password generation and permissions


--- sftp set up ----
-- add those lines to /etc/ssh/sshd_config

-- then run sudo systemctl restart ssh

-# configure sftp for customers

Subsystem sftp internal-sftp

-# match the group for sftp users

Match Group sftp-group

-# restrict access to user's home directory

ChrootDirectory %h/sftp

-# enable password authen

PasswordAuthentication yes

-# enable sftp only with no shell access

ForceCommand internal-sftp

-# disable GUI display

X11Forwarding no

-# disable tcp forwarding

AllowTcpForwarding no

