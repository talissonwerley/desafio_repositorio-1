## Projeto de Testes de Interface com Robot Framework - SauceDemo

Este repositório contém a parte de **testes automatizados de interface (UI) com Robot Framework** do desafio “[Desafio para QA - Talisson Werley de Maria](docs/1-Desafio%20para%20QA%20-%20Talisson%20Werley%20de%20Maria.pdf)”.

O sistema sob teste é o **SauceDemo** (`https://www.saucedemo.com`) e os fluxos cobertos aqui são:

- **Login**
- **Checkout**

Os cenários foram escritos em formato **BDD** utilizando Robot Framework.

---

### Estrutura do projeto

- `resources/`
  - `base.resource`: configuração base do Browser (Robot Framework Browser).
  - Demais arquivos de dados/apoio (ex: dados de login, checkout etc.).
- `pages/`  
  Arquivos `.resource` de **Page Objects** (login, inventário, carrinho, checkout, etc.).
- `keywords/`  
  Keywords de alto nível que compõem os cenários BDD.
- `tests/`  
  Suites Robot Framework (`.robot`) com os cenários de teste.
- `docs/`  
  PDF do desafio enviado pela empresa.
- `pyproject.toml`  
  Configuração de projeto Python, incluindo as dependências:
  - `robotframework`
  - `robotframework-browser`

---

### Pré-requisitos

- **Python** 3.11 (>= 3.11 e < 3.13, conforme `pyproject.toml`)
- `pip` atualizado
- Acesso à internet para o `rfbrowser init` baixar os artefatos do Playwright na primeira execução

---

### Configuração do ambiente local

1. **Clonar o repositório**

```bash
git clone https://github.com/<seu-usuario>/saucedemo-rf.git
cd saucedemo-rf
```

2. **(Opcional, mas recomendado) Criar e ativar um ambiente virtual**

```bash
python -m venv .venv
source .venv/Scripts/activate  # Windows (Git Bash/WSL)
# ou
.\.venv\Scripts\activate       # Windows (PowerShell)
```

3. **Instalar as dependências via `pyproject.toml`**

```bash
python -m pip install --upgrade pip
pip install .
```

4. **Inicializar o Robot Framework Browser (apenas na primeira vez)**

```bash
rfbrowser init
```

---

### Executando os testes localmente

Os testes estão organizados dentro da pasta `tests/`.  
Exemplo, para rodar todos os testes:

```bash
robot -d results tests
```

Isso irá gerar os relatórios padrão do Robot (`log.html`, `report.html`, `output.xml`) dentro da pasta `results/`.

Você também pode rodar apenas a suite de checkout, por exemplo:

```bash
robot -d results tests/checkout
```

---

### Integração Contínua com GitHub Actions

Este repositório contém um workflow do GitHub Actions em `.github/workflows/robot-tests.yml` que:

- Configura Python 3.11
- Instala as dependências (`pip install .`)
- Executa `rfbrowser init`
- Roda os testes Robot (`robot -d results tests`)
- Publica a pasta `results/` como **artefato** da execução

Os testes serão executados automaticamente em:

- `push` para os branches `main`/`master`
- `pull_request` direcionados para esses branches

Você poderá baixar os relatórios (`log.html`, `report.html`, `output.xml`) diretamente na aba **Actions** do GitHub, em cada execução do workflow.

---

### Observações do desafio

- Este repositório corresponde ao **Repositório 1 – Testes de Interface com Robot Framework**.
- A documentação aqui atende ao requisito de **explicar como executar os testes** e à integração com **GitHub Actions**.
