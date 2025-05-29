#!/bin/bash

# Solicita o e-mail do usuário
read -p "Digite seu e-mail associado ao GitHub: " USER_EMAIL

# Solicita o nome do usuário
read -p "Digite seu nome completo: " USER_NAME

# Verifica se já existe uma chave SSH
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "Chave SSH já existente encontrada em ~/.ssh/id_ed25519.pub"
else
    echo "Gerando nova chave SSH..."
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""
fi

# Inicia o agente SSH e adiciona a chave
echo "Iniciando o agente SSH e adicionando a chave..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Exibe a chave pública para o usuário copiar
echo ""
echo "=================== CHAVE PÚBLICA ==================="
cat ~/.ssh/id_ed25519.pub
echo "======================================================"
echo ""
echo "Copie a chave pública acima e cole nas configurações SSH da sua conta no GitHub."
read -p "Pressione ENTER depois de adicionar a chave na sua conta para continuar..."

# Configura nome e e-mail no Git
echo "Configurando nome e e-mail no Git..."
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

# Testa a conexão SSH com o GitHub
echo "Testando conexão SSH com github.com..."
ssh -T git@github.com || echo "Teste SSH falhou. Verifique a chave na sua conta."

echo "=== Configuração concluída! ==="
echo "Lembre-se de clonar seus repositórios usando o link SSH, por exemplo:"
echo "git clone git@github.com:usuario/repositorio.git"
#!/bin/bash

# Variáveis
SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_CONFIG="$HOME/.ssh/config"

echo "=== Gerando chave SSH (ed25519) ==="
if [ ! -f "$SSH_KEY" ]; then
    ssh-keygen -t ed25519 -C "$(git config user.email)" -f "$SSH_KEY" -N ""
    echo "Chave SSH criada em $SSH_KEY"
else
    echo "Chave SSH já existe em $SSH_KEY"
fi

echo "=== Iniciando ssh-agent e adicionando chave ==="
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi
ssh-add -l >/dev/null 2>&1
if [ $? -ne 0 ]; then
    ssh-add "$SSH_KEY"
fi

echo "=== Configurando ~/.ssh/config para usar a chave correta no GitHub ==="
mkdir -p "$(dirname "$SSH_CONFIG")"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    cat >> "$SSH_CONFIG" << EOF

Host github.com
  HostName github.com
  User git
  IdentityFile $SSH_KEY
  IdentitiesOnly yes
EOF
    echo "Arquivo $SSH_CONFIG atualizado."
else
    echo "Configuração para github.com já existe no $SSH_CONFIG"
fi

echo "=== Adicione esta chave pública no GitHub agora ==="
echo "Copie e cole a seguinte chave pública na sua conta GitHub em: https://github.com/settings/ssh/new"
echo "-------------------------------------------------------"
cat "$SSH_KEY.pub"
echo "-------------------------------------------------------"

read -p "Pressione ENTER depois de adicionar a chave no GitHub para testar a conexão..."

echo "=== Testando conexão SSH com GitHub ==="
ssh -T git@github.com

echo "=== Feito! Lembre-se de rodar 'source ~/.bashrc' para garantir que ssh-agent rode no seu shell ==="
