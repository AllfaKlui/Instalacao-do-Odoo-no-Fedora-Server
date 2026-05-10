#!/bin/bash
# ==============================================================================
# Script de Instalação Automatizada ERP (Odoo via Docker) - Fedora Server
# ==============================================================================

echo "[Etapa 1] - Atualizando o sistema operacional..."
sudo dnf update -y

echo "[Etapa 2] - Instalando dependências e ferramentas base..."
# Trocamos os pacotes de compilação pelo Git e a Engine do Docker
sudo dnf install git moby-engine -y

echo "[Etapa 3] - Habilitando o serviço do Docker..."
# Garante que o Docker inicie com o sistema
sudo systemctl enable --now docker

echo "[Etapa 4] - Configuração de Redes e Firewall..."
# Liberação da porta 8069 no Firewalld
sudo firewall-cmd --zone=public --add-port=8069/tcp --permanent
sudo firewall-cmd --reload

echo "[Etapa 5] - Orquestração dos Containers (Banco + Odoo)..."
# 5.1: Cria a rede isolada (ignora erro se já existir)
sudo docker network create odoo-nw 2>/dev/null

# 5.2: Sobe o container do PostgreSQL já configurado com usuário/senha padrão
sudo docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db --network odoo-nw postgres:15

# Dá um respiro de 5 segundos para o banco iniciar antes de subir a aplicação
sleep 5

# 5.3: Sobe o Odoo linkado ao banco
sudo docker run -d -p 8069:8069 --name odoo --network odoo-nw --link db:db -t odoo:17

echo "=============================================================================="
echo "Sucesso! O ambiente foi provisionado."
echo "Para acessar, rode 'ip a' para ver seu IP (pode usar modo NAT no Senac)."
echo "Acesse no navegador: http://<SEU_IP>:8069"
echo "=============================================================================="