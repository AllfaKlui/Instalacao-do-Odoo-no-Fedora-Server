#!/bin/bash
# ==============================================================================
# Script de Preparação de Ambiente ERP (Odoo) - Fedora Server (Via Docker)
# ==============================================================================

echo "[Etapa 1] - Atualizando o sistema operacional..."
sudo dnf update -y

echo "[Etapa 2] - Instalando motor Docker e ferramentas..."
# Instalamos o Docker e o Git (para o seu clone funcionar)
sudo dnf install moby-engine git -y
sudo systemctl enable --now docker

echo "[Etapa 3] - Configurando a Infraestrutura de Rede..."
# Criamos a rede para o Odoo e o Banco conversarem isoladamente
sudo docker network create odoo-nw 2>/dev/null

echo "[Etapa 4] - Configuração de Firewall..."
# Liberação da porta 8069 para acesso externo
sudo firewall-cmd --zone=public --add-port=8069/tcp --permanent
sudo firewall-cmd --reload

echo "[Etapa 5] - Subindo os Serviços (Banco + ERP)..."
# Sobe o PostgreSQL (O coração dos dados)
sudo docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db --network odoo-nw postgres:15

# Aguarda o banco iniciar
sleep 5

# Sobe o Odoo linkado ao banco
sudo docker run -d -p 8069:8069 --name odoo --network odoo-nw --link db:db -t odoo:17

echo "=============================================================================="
echo "Servidor Fedora 100% pronto e funcional!"
echo "Acesse no navegador: http://$(hostname -I | awk '{print $1}'):8069"
echo "=============================================================================="