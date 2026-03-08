# Testes de Interface com Robot Framework — SauceDemo

Este repositório contém os **testes automatizados de interface (UI)** com **Robot Framework** e **Browser Library** (Playwright) para o [SauceDemo](https://www.saucedemo.com). Os cenários estão escritos em formato **BDD** e cobrem os fluxos:

- **Login** — credenciais válidas, inválidas, usuário bloqueado e campos vazios
- **Checkout** — fluxo completo, múltiplos itens, validação de campos obrigatórios e cancelamento

---

## Estrutura do projeto

| Pasta / arquivo | Descrição                                                                                                            |
| --------------- | -------------------------------------------------------------------------------------------------------------------- |
| `resources/`    | `base.resource` (browser, contexto, viewport, vídeo, screenshot em falha; headless em CI), dados de login e checkout |
| `pages/`        | Page Objects (`.resource`) — login, inventário, carrinho, checkout (informações, overview, conclusão)                |
| `keywords/`     | Keywords em estilo BDD (login e checkout)                                                                            |
| `tests/`        | Suites Robot — `login/`, `checkout/`                                                                                 |

| `pyproject.toml` | Projeto Python — dependências: `robotframework`, `robotframework-browser` |

A configuração central do browser (Chromium) está em `base.resource`: viewport padrão 1280×720, gravação de vídeo por contexto, screenshot automático em caso de falha e execução headless quando a variável de ambiente `GITHUB_ACTIONS` está definida.

---

## Pré-requisitos

- **Python** 3.11 (compatível com 3.11 e &lt; 3.13, conforme `pyproject.toml`)
- `pip` atualizado
- Acesso à internet para o `rfbrowser init` (download dos binários do Playwright na primeira vez)

---

## Configuração do ambiente local

1. **Clonar o repositório**

```bash
git clone https://github.com/talissonwerley/desafio_repositorio-1.git
cd desafio_repositorio-1
```

2. **(Recomendado) Criar e ativar um ambiente virtual**

```bash
python -m venv .venv
.\.venv\Scripts\activate       # Windows (PowerShell)
# ou: source .venv/Scripts/activate   # Windows (Git Bash) / Linux / macOS
```

3. **Instalar dependências**

```bash
python -m pip install --upgrade pip
pip install .
```

4. **Inicializar o Robot Framework Browser (uma vez)**

```bash
rfbrowser init
```

---

## Executando os testes

Todos os testes (login + checkout):

```bash
robot -d results tests
```

Apenas uma suite:

```bash
robot -d results tests/login
robot -d results tests/checkout
```

Um teste específico:

```bash
robot -d results --test "LOGIN-01*" tests/login/login.robot
robot -d results --test "CHECKOUT-01*" tests/checkout/checkout.robot
```

---

## Estrutura de resultados

A execução gera a pasta `results/` com:

- **log.html** — log detalhado da execução
- **report.html** — relatório de resumo
- **output.xml** — saída em XML (integrações/parsers)
- **screenshots/** — capturas de tela em caso de falha (vinculadas ao `log.html`)
- **videos/** — gravações da execução por contexto do browser

Os relatórios e mídias ficam na mesma pasta para uso local ou após download do artefato no GitHub Actions.

---

## Integração contínua (GitHub Actions)

O workflow em `.github/workflows/robot-tests.yml`:

- Usa Python 3.11
- Instala dependências (`pip install .`) e executa `rfbrowser init`
- **Execução paralela:** roda duas suítes em jobs simultâneos (matrix) — um job para `tests/login`, outro para `tests/checkout` — com browser em modo headless
- Faz upload de dois artefatos: **robot-results-login** e **robot-results-checkout** (cada um com `log.html`, `report.html`, `output.xml`, `screenshots/` e `videos/` da suíte correspondente)

Disparo: em **push** e **pull_request** para os branches `main` e `master`.

Na aba **Actions** do repositório, em cada execução aparecem os dois artefatos para download; com `fail-fast: false`, a falha de uma suíte não interrompe a outra.

---

## Observações

- Este repositório corresponde ao **Repositório 1 – Testes de Interface com Robot Framework** do desafio de QA.
- A documentação acima atende ao requisito de explicar como executar os testes e à integração com GitHub Actions.
