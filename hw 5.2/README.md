- Задача 1

    Опишите своими словами основные преимущества применения на практике IaaC паттернов.
    Какой из принципов IaaC является основополагающим?
	
```
Главным преимуществом IaaC является то, что выполнение развертывания инфраструктуры и архитектуры таким образом индепотемтно. Каждый раз развертывая инфрастурктуру вы получаете одинаковый результат.
```

- Задача 2

    Чем Ansible выгодно отличается от других систем управление конфигурациями?
    Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
```
Ansible не требует развернутых агентов на хостовых машинах, а используется стоковый ssh. Для развертывания конфигурации, инсталяции продуктов и тд используются штатные средства целевой системы, управляемые по ssh.
Соответственно push всегда более надежен. Не важно запущен агент или нет, не важно, в каком состоянии находится целевая система, просто подключаемся, выполняем команды и получаем ответ. 
```


- Задача 3

Установить на личный компьютер:

    VirtualBox
    Vagrant
    Ansible

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

Вместо vbox установлен hyperv. Собственно все дальнейшие действия осуществляются с ним как с основным гипервизором.
Vagrant
```
PS C:\Windows\system32> vagrant -v
Vagrant 2.2.19
```
Ansible устанавливается внутрь виртуальной машины и запускается далее через ansible_locale

Конфиги для vagrant
```ruby
ISO = "generic/debian11"
DOMAIN = ".netology"
HOST_PREFIX = "mx."
INVENTORY_PATH = "/vagrant/inventory"
servers = [
  {
    :hostname => HOST_PREFIX + "1" + DOMAIN,
    :ram => 1024,
    :core => 1,
    :bridge => "lan"
  }
]

Vagrant.configure(2) do |config|
  config.vm.synced_folder "C:/cygwin64/etc/ansible", "/vagrant", type: "smb", disabled: false, smb_password: "123", smb_username: "123"
  servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = ISO
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", bridge: machine[:bridge], ip: machine[:ip]
            node.vm.provider "hyperv" do |h|
                 h.linked_clone = true
                 h.vm_integration_services = { 
                     guest_service_interface: true
                 }
                 #h.cpus = machine[:core]
                 #h.maxmemory = machine[:ram]
                 h.vmname = machine[:hostname]
            end
            node.vm.provision "shell", inline: <<-SHELL
                apt-get update
                apt-get install -y ansible
                SHELL
            node.vm.provision "ansible_local" do |setup|
                setup.inventory_path = INVENTORY_PATH
                setup.playbook = "/vagrant/playbook.yml"
				setup.become = true
                setup.extra_vars = { ansible_user: 'vagrant' } 
            end
        end
    end
end
```
Конфиг для ansible playbook
```yaml
---  
— hosts: nodes    
  connection: local    
  tasks:      
	— name: Create directory for ssh-keys        
	  file: state=directory mode=0700 dest=/root/.ssh/      
	— name: Adding rsa-key in /root/.ssh/authorized_keys        
	  copy: src=~/vagrant/id_rsa.pub dest=/root/.ssh/authorized_keys owner=root mode=0600        
	  ignore_errors: yes      
	— name: Checking DNS        
	  command: host -t A google.com
	— name: Installing tools        
		apt: >          
			package={{ item }}          
			state=present          
			update_cache=yes        
		with_items:          
			— git          
			— curl      
	— name: Installing docker        
		shell: curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh && ./get-docker.sh      
	— name: Add the current user to docker group        
		user: name=vagrant append=yes groups=docker
```



- Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

    Создать виртуальную машину.
    Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды

docker ps

```
PS C:\Windows\system32> vagrant ssh
vagrant@mx:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```


Это конечно потребовало определенных ресурсов. Запустить все не так как в ДЗ, но понять, что и как, настроить и разобраться. 