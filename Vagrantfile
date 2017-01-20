VAGRANTFILE_API_VERSION = "2"

IMAGE_NAME = "centos7-web-db-server"
INSTALL_SCRIPT = "./install.sh"
IP_ADDRESS = "192.168.1.100"
IMAGE_BOX = "centos/7"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = IMAGE_BOX
  config.vm.provider :virtualbox do |vb|
    vb.name = IMAGE_NAME
  end
  config.vm.network "public_network", ip: IP_ADDRESS, bridge: "en0: Wi-Fi (AirPort)"
  config.vm.synced_folder "../", "/git"
  config.vm.provision "shell", :path => INSTALL_SCRIPT
  config.ssh.insert_key = false
end
