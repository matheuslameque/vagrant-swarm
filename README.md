# Configuração do Docker Swarm com Vagrant

Este projeto fornece scripts para configurar um cluster Docker Swarm usando Vagrant, com um nó mestre e nós trabalhadores.

## Estrutura do Projeto

* `docker.sh`: Script para instalar o Docker em uma máquina Ubuntu e configurá-lo para uso com Vagrant.

* `master.sh`: Script para inicializar o nó mestre do Docker Swarm e gerar o comando de junção para os nós trabalhadores.

* `worker.sh`: Script para os nós trabalhadores esperarem e executarem o comando de junção gerado pelo nó mestre.

## Pré-requisitos

* [Vagrant](https://www.vagrantup.com/downloads)

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (ou outro provedor de virtualização compatível com Vagrant)

## Como Usar

### 1. Configuração do Vagrantfile

Certifique-se de que seu `Vagrantfile` esteja configurado para provisionar as máquinas virtuais com os scripts `docker.sh`, `master.sh` e `worker.sh` nos nós apropriados. Um exemplo de `Vagrantfile` pode ser parecido com isto:

```ruby
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", ip: "192.168.56.102"
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "docker.sh"
    master.vm.provision "shell", path: "master.sh"
  end

  config.vm.define "worker1" do |worker|
    worker.vm.box = "ubuntu/focal64"
    worker.vm.network "private_network", ip: "192.168.56.103"
    worker.vm.hostname = "worker1"
    worker.vm.provision "shell", path: "docker.sh"
    worker.vm.provision "shell", path: "worker.sh"
  end

  # Adicione mais nós trabalhadores conforme necessário
  config.vm.define "worker2" do |worker|
    worker.vm.box = "ubuntu/focal64"
    worker.vm.network "private_network", ip: "192.168.56.104"
    worker.vm.hostname = "worker2"
    worker.vm.provision "shell", path: "docker.sh"
    worker.vm.provision "shell", path: "worker.sh"
  end
end
```

### 2. Inicializar as Máquinas Virtuais

Navegue até o diretório onde seu Vagrantfile e os scripts .sh estão localizados e execute:

`vagrant up`

Este comando irá:

* Provisionar as máquinas virtuais (mestre e trabalhadores).

* Executar `docker.sh` em todas as máquinas para instalar o Docker.

* Executar `master.sh` no nó mestre para inicializar o Swarm e gerar o comando de junção.

* Executar `worker.sh` nos nós trabalhadores, que esperarão pelo comando de junção e se juntarão ao Swarm.

### 3. Verificar o Status do Swarm

Após o vagrant up ser concluído, você pode fazer SSH no nó mestre para verificar o status do seu cluster Docker Swarm:

```
vagrant ssh master
docker node ls
```

Você deverá ver o nó mestre e todos os nós trabalhadores listados com o status Ready.

#### Descrição dos Scripts:

`docker.sh`

Este script realiza as seguintes ações:

* Atualiza os pacotes do sistema.

* Instala as dependências necessárias para o Docker.

* Adiciona a chave GPG oficial do Docker.

* Configura o repositório do Docker para Ubuntu.

* Instala o Docker Engine, containerd e Docker Compose.

* Cria o grupo docker se ele não existir.

* Adiciona o usuário vagrant ao grupo docker para permitir a execução de comandos Docker sem sudo.

* Recarrega a associação ao grupo para o usuário vagrant.

`master.sh`

Este script realiza as seguintes ações no nó mestre:

* Inicializa um cluster Docker Swarm no nó atual, definindo-o como o nó gerenciador.

* Define o endereço de anúncio para 192.168.56.102.

* Obtém o token de junção do trabalhador do nó gerenciador do Docker Swarm.

* Concatena o comando completo para os nós trabalhadores se juntarem ao Swarm.

* Grava o comando de junção em um arquivo chamado worker_join_command.sh no diretório /vagrant (compartilhado com os nós trabalhadores).

* Adiciona uma linha shebang (#!/bin/bash) ao arquivo do script para garantir que ele seja executado como um script bash.

`worker.sh`

Este script realiza as seguintes ações nos nós trabalhadores:

* Define o caminho para o script de junção do trabalhador (/vagrant/worker_join_command.sh) que será criado pelo mestre.

* Espera que o script de junção do trabalhador seja criado pelo nó mestre (loop de espera).

* Torna o script de junção executável.

* Executa o comando de junção para que o nó trabalhador se junte ao cluster Docker Swarm.

#### Observações:

* O endereço IP 192.168.56.102 é usado como o endereço de anúncio para o nó mestre. Certifique-se de que este IP esteja disponível e configurado corretamente em seu Vagrantfile.

* Os scripts assumem que o diretório /vagrant é um diretório compartilhado entre as máquinas virtuais Vagrant, o que é o comportamento padrão.

#### Este setup é ideal para ambientes de desenvolvimento e teste de Docker Swarm.
