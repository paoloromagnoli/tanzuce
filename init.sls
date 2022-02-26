# install Tanzu Community Edition on Ubuntu 18.04 bionic

include:
  - tanzuce.user
  - tanzuce.docker
  - tanzuce.kubectl-snap


# create a directory to download the TCE release tar
create_directory:
  file.directory:
    - name: /tmp/tce
    - mode: 755
    - makedirs: True

# Download the TCE release from githb
#curl -H "Accept: application/vnd.github.v3.raw" -L https://api.github.com/repos/vmware-tanzu/community-edition/contents/hack/get-tce-release.sh | bash -s <RELEASE-VERSION> <RELEASE-OS-DISTRIBUTION>
download_tce:
  file.managed:
    - name: /tmp/tce/tce-linux-amd64-v0.10.0.tar.gz
    - source: https://github.com/vmware-tanzu/community-edition/releases/download/v0.10.0/tce-linux-amd64-v0.10.0.tar.gz
    - source_hash: 7b246bb22f2fabd1cd2ea07ce533f10a5c5955670827e734d8c549595d106e6f
    - mode: 644
    - requires:
      - create_directory

# untar the TCE release
extract_tce:
  archive.extracted:
    - name: /tmp/tce
    - source: /tmp/tce/tce-linux-amd64-v0.10.0.tar.gz
    - options: xzvf
    - requires:
      - download_tce

# run the install script
run_tce_installer:
  cmd.run:
    - name: /tmp/tce/tce-linux-amd64-v0.10.0/install.sh
    - runas: tce
    - requires: 
      - extract_tce
