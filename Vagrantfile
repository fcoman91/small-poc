WEB_COUNT = 2
INTERFACE = "wlp3s0"
NETWORK = "192.168.100."
WEB_START_IP = 100
LB_IP = 200

SRC_PUB_KEY = "/home/florian/.ssh/id_rsa.pub"
SRC_PRIVATE_KEY = "/home/florian/.ssh/id_rsa"
AUTHORIZED_FILE = "/home/vagrant/.ssh/authorized_keys"

Vagrant.configure("2") do |config|

    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.box = "centos/7"

    (1..WEB_COUNT).each do |web_server|
       config.vm.define "web#{web_server}" do |node|
          node.vm.provider "virtualbox" do |vb|
              vb.name = "web#{web_server}"
              vb.memory = 1024
              vb.cpus = 1
          end

          node.vm.hostname = "web#{web_server}"
          node.vm.network "public_network", bridge: "#{INTERFACE}", ip: NETWORK + "#{WEB_START_IP + web_server}"

          public_key = File.read("#{SRC_PUB_KEY}")
          node.vm.provision :shell, :inline =>
            "echo 'Add SSH public key to web#{web_server} machine'
             echo '#{public_key}' >> #{AUTHORIZED_FILE}"

          node.vm.provision "ansible" do |ansible|
              ansible.compatibility_mode = "2.0"
              ansible.playbook = "provisioning/web.yml"
          end
       end
    end

    config.vm.define "nginx" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "nginx"
            vb.memory = 1024
            vb.cpus = 1
        end

        node.vm.hostname = "nginx"
        node.vm.network "public_network", bridge: "#{INTERFACE}", ip: NETWORK + "#{LB_IP}"
       
        public_key = File.read("#{SRC_PUB_KEY}")
        node.vm.provision :shell, :inline =>
          "echo 'Add SSH public key to nginx machine'
           echo '#{public_key}' >> #{AUTHORIZED_FILE}"

        node.vm.provision "ansible" do |ansible|
            ansible.compatibility_mode = "2.0"
            ansible.playbook = "provisioning/nginx.yml"
            ansible.extra_vars = { private_key_path: "#{SRC_PRIVATE_KEY}" }
        end
    end
end