# -*- ruby -*-

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.network("192.168.10.35")
  config.vm.forward_port("ssh", 22, 2319, :auto => true)
  config.vm.share_folder("v-fixienews", "/apps/fixienews/shared-checkout", ".", :nfs => true)
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = ["config/cookbooks"]
  config.chef.log_level = :debug
end
# vim: syntax=ruby
