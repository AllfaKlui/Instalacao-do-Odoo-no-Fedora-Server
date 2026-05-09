#!/bin/bash
# ==============================================================================
# Script de Preparação de Ambiente ERP (Odoo) - Fedora Server
# ==============================================================================

echo "[Etapa 1] - Atualizando o sistema operacional..."
# Base mantida: Atualização do sistema
sudo dnf update -y

echo "[Etapa 2] - Instalando dependências e ferramentas..."
# Base mantida (Odoo): Instalação dos pacotes. 
# Adição: O parâmetro '-y' no final para o script não travar pedindo confirmação.
sudo dnf install python3-devel postgresql-server gcc libxslt-devel libxml2-devel git -y

echo "[Etapa 3] - Configurando e iniciando o Banco de Dados (PostgreSQL)..."
# ADIÇÃO CRÍTICA: Inicialização do cluster de dados do PostgreSQL.
sudo postgresql-setup --initdb
# ADIÇÃO: Inicialização do serviço (Daemon) no systemd
sudo systemctl enable --now postgresql

echo "[Etapa 4] - Configuração de Redes e Firewall..."
# ADIÇÃO CRÍTICA: Liberação de portas no Firewalld
sudo firewall-cmd --zone=public --add-port=8069/tcp --permanent
sudo firewall-cmd --reload

echo "[Etapa 5] - Conclusão e Próximos Passos"
echo "O servidor base está 100% pronto! O banco de dados está rodando e a porta 8069 está aberta."
echo "Próximo passo: Fazer o clone do repositório do Odoo ou subir via Docker."