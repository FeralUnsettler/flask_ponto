#!/bin/bash

# Verifica se o README.md existe
if [[ ! -f "README.md" ]]; then
  echo "README.md não encontrado!"
  exit 1
fi

# Função para criar diretórios e arquivos
create_structure() {
  echo "Criando estrutura do projeto..."

  # Diretórios
  mkdir -p app/{templates,static/{css,js},tests}

  # Arquivos com conteúdo específico
  echo "$DOCKERFILE_CONTENT" > Dockerfile
  echo "$DOCKER_COMPOSE_CONTENT" > docker-compose.yml
  echo "$REQUIREMENTS_CONTENT" > requirements.txt
  echo "$INIT_PY_CONTENT" > app/__init__.py
  echo "$MODELS_PY_CONTENT" > app/models.py
  echo "$ROUTES_PY_CONTENT" > app/routes.py
  echo "$INDEX_HTML_CONTENT" > app/templates/index.html
  echo "$COLABORADORES_HTML_CONTENT" > app/templates/colaboradores.html
  echo "$CADASTRO_COLABORADOR_HTML_CONTENT" > app/templates/cadastro_colaborador.html
  echo "$ALTERAR_COLABORADOR_HTML_CONTENT" > app/templates/alterar_colaborador.html
  echo "$REGISTRO_PONTO_HTML_CONTENT" > app/templates/registro_ponto.html
  echo "$STYLES_CSS_CONTENT" > app/static/css/styles.css
  echo "$SCRIPTS_JS_CONTENT" > app/static/js/scripts.js
  echo "$TEST_COLABORADORES_PY_CONTENT" > app/tests/test_colaboradores.py
  echo "$MANAGE_PY_CONTENT" > manage.py

  echo "Estrutura do projeto criada com sucesso!"
}

# Extrai conteúdo de cada seção do README.md
extract_content() {
  DOCKERFILE_CONTENT=$(sed -n '/### Dockerfile/,/### docker-compose.yml/p' README.md | sed '$d')
  DOCKER_COMPOSE_CONTENT=$(sed -n '/### docker-compose.yml/,/### requirements.txt/p' README.md | sed '$d')
  REQUIREMENTS_CONTENT=$(sed -n '/### requirements.txt/,/### app\/__init__.py/p' README.md | sed '$d')
  INIT_PY_CONTENT=$(sed -n '/### app\/__init__.py/,/### app\/models.py/p' README.md | sed '$d')
  MODELS_PY_CONTENT=$(sed -n '/### app\/models.py/,/### app\/routes.py/p' README.md | sed '$d')
  ROUTES_PY_CONTENT=$(sed -n '/### app\/routes.py/,/### app\/templates\/index.html/p' README.md | sed '$d')
  INDEX_HTML_CONTENT=$(sed -n '/### app\/templates\/index.html/,/### app\/templates\/colaboradores.html/p' README.md | sed '$d')
  COLABORADORES_HTML_CONTENT=$(sed -n '/### app\/templates\/colaboradores.html/,/### app\/templates\/cadastro_colaborador.html/p' README.md | sed '$d')
  CADASTRO_COLABORADOR_HTML_CONTENT=$(sed -n '/### app\/templates\/cadastro_colaborador.html/,/### app\/templates\/alterar_colaborador.html/p' README.md | sed '$d')
  ALTERAR_COLABORADOR_HTML_CONTENT=$(sed -n '/### app\/templates\/alterar_colaborador.html/,/### app\/templates\/registro_ponto.html/p' README.md | sed '$d')
  REGISTRO_PONTO_HTML_CONTENT=$(sed -n '/### app\/templates\/registro_ponto.html/,/### app\/static\/css\/styles.css/p' README.md | sed '$d')
  STYLES_CSS_CONTENT=$(sed -n '/### app\/static\/css\/styles.css/,/### app\/static\/js\/scripts.js/p' README.md | sed '$d')
  SCRIPTS_JS_CONTENT=$(sed -n '/### app\/static\/js\/scripts.js/,/### app\/tests\/test_colaboradores.py/p' README.md | sed '$d')
  TEST_COLABORADORES_PY_CONTENT=$(sed -n '/### app\/tests\/test_colaboradores.py/,/### manage.py/p' README.md | sed '$d')
  MANAGE_PY_CONTENT=$(sed -n '/### manage.py/,/^### Requisitos Funcionais/p' README.md | sed '$d')
}

# Executa as funções
extract_content
create_structure
