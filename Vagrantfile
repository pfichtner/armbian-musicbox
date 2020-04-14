$script = <<-SCRIPT
sudo -E apt-get update && apt-get install -y p7zip parted kpartx qemu-user-static
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian9"
  config.vm.provision "shell", inline: $script
  # config.vm.network "forwarded_port", guest: 6680, host: 8888
  # config.vm.network "forwarded_port", guest: 6600, host: 6600
  # config.ssh.forward_x11 = true
  config.vm.provider "virtualbox" do |v|
     v.memory = 2048
     v.cpus = 2
  #   v.customize [
  #     "modifyvm", :id,
  #     "--ioapic", "on",
  #     "--audio", "pulse",
  #     "--audiocontroller", "ac97"
  #   ]
  end
end

