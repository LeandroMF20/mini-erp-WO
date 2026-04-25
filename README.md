# PHP Docker Template

Esta é uma base mínima para desenvolvimento PHP com Docker, Xdebug e VS Code. Servindo como ponto de partida para projetos com PHP puro, Laravel, CodeIgniter 4 ou qualquer outro framework.

---

## Requisitos

- [Docker](https://www.docker.com/) + Docker Compose
- [VS Code](https://code.visualstudio.com/) com a extensão [PHP Debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

---

## Estrutura

```
.vscode/
  launch.json        # Configuração de debug para o VS Code
docker/
  .env.example       # Variáveis de ambiente — copie para .env antes de subir
  docker-compose.yml
  php/
    Dockerfile
    xdebug.ini
public/
  index.php          # Ponto de entrada da aplicação
```

---

## Como usar (Template - recomendado)

1. No canto superior direito clique em "Use this template".
2. Selecione "Create a new repository".
3. Preencha os campos da mesma forma que faria se fosse criar um novo repositório e finalize a criação dele.

Fazendo desta forma não é necessário fazer a troca do vínculo dos repositórios remotos e o histórico de commits fica limpo por padrão.

## Como usar (git clone)

### 1. Clone o repositório

```bash
git clone https://github.com/LeandroMF20/php-docker-template.git php-docker-template
cd meu-projeto
```

### 2. Mude o Vínculo

```bash
git remote remove origin
git remote add origin https://github.com/seu-usuario/novo-projeto.git
git push -u origin main
```

### 3. Configure o ambiente

```bash
cp docker/.env.example docker/.env
```

Edite `docker/.env` se precisar ajustar credenciais do banco ou configurações do Xdebug.

### 4. Suba os containers

```bash
cd docker
docker compose up -d --build
```

A aplicação estará disponível em [http://localhost:8080](http://localhost:8080).  
O MySQL estará exposto na porta `3306`.

## Debug com Xdebug no VS Code

1. Instale a extensão [PHP Debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug).
2. Abra a aba **Run and Debug** (`Ctrl+Shift+D`).
3. Selecione **Listen for Xdebug (Docker)**.
4. Coloque um breakpoint em qualquer arquivo PHP.
5. Acesse [http://localhost:8080](http://localhost:8080) no navegador — o VS Code irá pausar no breakpoint.

### Como funciona o Xdebug nesse setup

- **Linux:** o `extra_hosts` no Compose mapeia `host.docker.internal` para o gateway do host automaticamente.
- **Windows/macOS:** o Docker Desktop já resolve `host.docker.internal` nativamente.

---

## Variáveis de ambiente (`docker/.env`)

| Variável                    | Padrão                  | Descrição                              |
|-----------------------------|-------------------------|----------------------------------------|
| `MYSQL_ROOT_PASSWORD`       | `root`                  | Senha do root do MySQL                 |
| `MYSQL_DATABASE`            | `app_database`          | Nome do banco criado automaticamente   |
| `MYSQL_USER`                | `dev`                   | Usuário do banco                       |
| `MYSQL_PASSWORD`            | `secret`                | Senha do usuário                       |
| `XDEBUG_CLIENT_HOST`        | `host.docker.internal`  | Host da máquina para o Xdebug conectar |
| `XDEBUG_CLIENT_PORT`        | `9003`                  | Porta do cliente de debug              |
| `XDEBUG_DISCOVER_CLIENT_HOST` | `1`                   | Descoberta automática do host          |

---

## Adaptando para um novo projeto

1. Copie este repositório (ou use como template no GitHub).
2. Ajuste o `DocumentRoot` no `Dockerfile` se necessário (ex: Laravel usa `/var/www/html/public`).
3. Adicione extensões PHP no `Dockerfile` conforme o framework escolhido.
4. Atualize `docker/.env` com as credenciais reais do projeto.
5. Remova ou substitua `public/index.php` pelo código da aplicação.
