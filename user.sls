# create  user for TCE

# create tce user
create_tce_user:
  user.present:
    - name: tce
    - home: /home/tce
    - empty_password: True
    - groups:
      - sudo

# prevent user login with password
# https://kifarunix.com/disable-ssh-password-login-for-specific-users-in-ubuntu-18-04/#:~:text=If%20you%20need%20to%20disable,login%20using%20SSH%20public%20key
prevent_user_login:
  file.append:
    - name: /etc/ssh/sshd_config
    - text:
      - "Match   User    tce"
      - "        PasswordAuthentication  no"

su_without_password_line1:
  file.line:
    - name: /etc/pam.d/su
    - mode: insert
    - after: auth       sufficient pam_rootok.so
    - content: auth       [success=ignore default=1] pam_succeed_if.so user = tce

su_without_passwordline2:
  file.line:
    - name: /etc/pam.d/su
    - mode: insert
    - after: auth       [success=ignore default=1] pam_succeed_if.so user = tce
    - content: auth       sufficient   pam_succeed_if.so use_uid user ingroup sudo

# reload ssh service
# reload_ssh:
#  service.running:
#    - name: ssh
#    - reload: True
#    - watch:
#      - prevent_user_login

# add user to password-less sudoers
# https://askubuntu.com/questions/192050/how-to-run-sudo-command-with-no-password
create_sudoers_file:
  file.managed:
    - name: /etc/sudoers.d/tce
    - contents:
      - tce ALL=(ALL) NOPASSWD:ALL

# restart sudo
# restart_sudo:
#  service.running:
#    - name: sudo
#    - enable: True
#    - watch:
#      - create_sudoers_file

# make user parametric
create_docker_group:
  group.present:
    - name: docker
    - addusers:
      - tce