# install docker on Ubuntu 18.04 bionic
# https://docs.docker.com/engine/install/ubuntu/

# pre requisites
#   - python-apt package is required to be installed. To check if this package is installed, run dpkg -l python-apt. python-apt will need to be manually installed if it is not present.

# known limitation
# this state doesn't perform any check on cgroup so you should do it manually as mentioned in the doc below
# https://tanzucommunityedition.io/docs/latest/support-matrix/#check-and-set-the-cgroup

# uninstall old versions
uninstall_old_versions:
  pkg.removed:
    - pkgs: 
      - docker
      - docker-engine
      - docker.io 
      - containerd 
      - runc

# install packages required to manage the apt repository
install_required_packages:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
    - refresh: True

# download the gpg keyfile
#add_docker_keyring_gpg_file:
#  file.managed:
#    - name: /usr/share/keyrings/docker-archive-keyring.gpg
#    - source: https://download.docker.com/linux/ubuntu/gpg
#    - source_hash: 1500c1f56fa9e26b9b8f42452a553675796ade0807cdce11975eb98170b3a570
#    - mode: 644
#    - requires:
#      - install_required_packages

# set up the Docker repository
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# this add the key in the /etc/apt/source.list file instead of creating a docker dedicated file /etc/apt/source.list.d/docker.list
install_docker_repo:
  pkgrepo.managed:
    - humanname: Docker Stable Repository
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ grains['oscodename'] }} stable
#    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - gpgcheck: 1
    - require_in:
      - pkg: install_docker

install_docker:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - refresh: True
    - requires:
      - install_docker_repo

# configure docker to start on boot
# https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot

enable_docker:
  service.running:
    - name: docker
    - enable: true

enable_containerd:
  service.running:
    - name: containerd
    - enable: true