VAGRANTFILE_API_VERSION = "2"

IMAGE_NAME = "centos7-web-db-server"
IP_ADDRESS = "192.168.1.100"
IMAGE_BOX = "centos/7"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = IMAGE_BOX
  config.vm.provider :virtualbox do |vb|
    vb.name = IMAGE_NAME
    vb.memory = 4096
    vb.gui = true
  end
  config.vm.network "public_network", ip: IP_ADDRESS, bridge: "en0: Wi-Fi (AirPort)"
  config.vm.provision :shell do |shell|
    shell.path = "./install.sh"
    shell.path = "./app.sh"
  end
  config.ssh.insert_key = false
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true
end
