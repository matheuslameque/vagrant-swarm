machines = {
    "master" => {"memory" => "512", "cpus" => "1", "box" => "ubuntu/jammy64", "ip" => "102"},
    "node1"  => {"memory" => "512",  "cpus" => "1", "box" => "ubuntu/jammy64", "ip" => "103"},
    "node2"  => {"memory" => "512",  "cpus" => "1", "box" => "ubuntu/jammy64", "ip" => "104"},
    "node3"  => {"memory" => "512",  "cpus" => "1", "box" => "ubuntu/jammy64", "ip" => "105"}
  }

Vagrant.configure("2") do |config|  

  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["box"]}"
      machine.vm.hostname = "#{name}"
      machine.vm.network "private_network", ip: "192.168.56.#{conf["ip"]}"      

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpus"]        
      end

      machine.vm.provision "shell", path: "docker.sh"

      if name == "master"        
        machine.vm.provision "shell", path: "master.sh", run: "always"
      else        
        machine.vm.provision "shell", path: "worker.sh", run: "always"
      end
    end
  end
end
