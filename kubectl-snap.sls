# install kubectl with snap

install_kubectl_with_snap:
  cmd.run:
    - name: sudo snap install kubectl --classic
    - runas: tce