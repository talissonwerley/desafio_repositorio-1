# Relatório Técnico — Automação de Testes de Interface (SauceDemo)

**Projeto:** Testes de UI com Robot Framework e Browser Library (Playwright)  
**Aplicação sob teste:** [SauceDemo](https://www.saucedemo.com)  
**Documento:** Apresentação da implementação da automação para gestão  

---

## 1. Visão Geral do Projeto

### Objetivo da automação

O projeto automatiza testes de interface (UI) do SauceDemo, um e-commerce fictício usado como alvo de testes. A automação cobre os fluxos críticos de **Login** e **Checkout**, garantindo que as funcionalidades principais sejam validadas de forma repetível e integrada ao pipeline de CI.

### Tecnologia utilizada

- **Robot Framework** — framework de automação e orquestração dos testes  
- **Browser Library** — biblioteca que utiliza o **Playwright** para controle do navegador (Chromium)  
- **Python** 3.11 — runtime e dependências gerenciadas via `pyproject.toml`  

### Tipo de aplicação testada

Aplicação web (SauceDemo) com páginas de login, inventário, carrinho e checkout em múltiplas etapas. Não há API exposta; toda a validação é feita via interface.

### Estratégia geral da automação

- **Cenários em formato BDD** (Dado/Quando/Então) para legibilidade e alinhamento com regras de negócio  
- **Page Object** e **keywords reutilizáveis** para separar localizadores e ações da lógica dos testes  
- **Configuração centralizada** do browser (viewport, vídeo, screenshot em falha, headless no CI) em um único resource  
- **Dados de teste** em arquivos `.resource` separados (login e checkout), facilitando manutenção e variação de cenários  
- **Execução paralela no CI:** as suítes Login e Checkout rodam em jobs separados no GitHub Actions, reduzindo o tempo total da pipeline  

---

## 2. Arquitetura da Automação

### Estrutura de pastas

```
saucedemo-rf/
├── .github/workflows/
│   └── robot-tests.yml          # Pipeline CI (GitHub Actions)
├── resources/
│   ├── base.resource            # Configuração do browser, keywords de abertura/fechamento
│   ├── login_data.resource      # Usuários, senhas e mensagens de erro de login
│   └── checkout_data.resource   # Dados de checkout e valores esperados do resumo
├── pages/
│   ├── login_page.resource
│   ├── inventory_page.resource
│   ├── cart_page.resource
│   ├── checkout_information_page.resource
│   ├── checkout_overview_page.resource
│   └── checkout_complete_page.resource
├── keywords/
│   ├── login_keywords.resource    # Keywords BDD de login
│   └── checkout_keywords.resource # Keywords BDD de checkout
├── tests/
│   ├── login/
│   │   └── login.robot           # Suite de login
│   └── checkout/
│       └── checkout.robot        # Suite de checkout
├── pyproject.toml
└── docs/
```

### Organização dos testes

- **Suites por fluxo:** uma suite para Login (`tests/login/login.robot`) e uma para Checkout (`tests/checkout/checkout.robot`).  
- **Cada arquivo `.robot`** importa apenas os resources necessários (base, dados e keywords daquele fluxo).  
- **Setup/Teardown:** os testes de login usam `Test Teardown    Fechar navegador`; os de checkout idem. O login ainda define `Test Setup    Nenhuma configuração inicial` (No Operation). Assim, o browser é fechado após cada caso de teste.

### Uso de Page Objects / Resources

- **`resources/base.resource`** — ponto único de configuração do browser: inicialização, contexto com gravação de vídeo, viewport padrão (1280×720), screenshot automático em falha e detecção de CI para modo headless. Contém as keywords `Abrir Saucedemo`, `Fechar navegador` e `Capturar screenshot em falha`.  
- **`pages/*.resource`** — cada arquivo representa uma tela (ou etapa) e expõe keywords que encapsulam localizadores e ações (ex.: `Preencher usuário`, `Clicar em Login`, `Deve estar na página de inventário`). Os pages importam apenas o `base.resource`.  
- **`resources/login_data.resource`** e **`checkout_data.resource`** — variáveis de dados (usuários, senhas, mensagens de erro, valores esperados de totais). Os testes e as keywords referenciam essas variáveis, mantendo os cenários desacoplados dos valores concretos.

### Separação entre testes e keywords

- Os arquivos **`.robot`** contêm apenas definição de **Test Cases** (e Settings como Resource, Setup, Teardown). Os passos dos testes são escritos em linguagem BDD chamando keywords.  
- Toda a orquestração (Dado/Quando/Então) está em **`keywords/login_keywords.resource`** e **`keywords/checkout_keywords.resource`**. Essas keywords chamam, por sua vez, as keywords dos **pages** e do **base**.  
- Nenhum localizador (id, css) ou comando direto do Browser (Click, Fill Text, Get Text) aparece nos arquivos de teste; isso fica nos pages e no base.

### Vantagens dessa abordagem

- **Manutenção:** alteração de um seletor ou de um passo de fluxo é feita em um único arquivo (page ou keyword), sem espalhar mudanças nos testes.  
- **Reutilização:** as mesmas keywords de page e de fluxo podem ser usadas em novas suites (ex.: outros fluxos que precisem de login ou checkout).  
- **Clareza:** os casos de teste leem como especificação (BDD), enquanto a implementação técnica fica nos resources e pages.  
- **Testabilidade:** dados em arquivos dedicados permitem adicionar cenários (ex.: novos usuários ou mensagens) sem alterar a lógica dos testes.  

---

## 3. Tecnologias Utilizadas

| Tecnologia | Papel no projeto |
|------------|------------------|
| **Robot Framework** | Orquestra a execução dos testes, gerencia suites, relatórios (log.html, report.html, output.xml) e a keyword `run_on_failure` para screenshot automático. |
| **Browser Library (Playwright)** | Controla o navegador Chromium (New Browser, New Context, New Page), interage com a página (Click, Fill Text, Get Text, Wait For Elements State) e oferece gravação de vídeo e screenshot. |
| **Python** | Runtime do Robot Framework e das bibliotecas; versão 3.11, dependências declaradas em `pyproject.toml` (robotframework, robotframework-browser). |
| **GitHub Actions** | Pipeline de CI com execução paralela (matrix login/checkout): checkout, setup Python, instalação de dependências, `rfbrowser init`, execução por suíte e upload de artefatos `robot-results-login` e `robot-results-checkout`. |
| **Relatórios do Robot Framework** | log.html (detalhado), report.html (resumo) e output.xml (máquina); gerados em `results/` junto com screenshots e vídeos. |

---

## 4. Fluxo de Execução dos Testes

### Execução local

1. Desenvolvedor ativa o ambiente (ex.: `pip install .`, `rfbrowser init` se necessário).  
2. Comando típico: `robot -d results tests` (todos os testes) ou `robot -d results tests/login` / `robot -d results tests/checkout` (por suite).  
3. O Robot Framework carrega as suites, importa os resources e, para cada teste, executa as keywords. O browser é iniciado pela keyword `Abrir Saucedemo` (chamada diretamente no login ou indiretamente no checkout via “Dado que estou logado como usuário padrão”) e fechado no Teardown.  
4. Saída é gravada em `results/`: log.html, report.html, output.xml; `results/screenshots/` e `results/videos/` são criados e preenchidos conforme a execução (screenshot em falha e vídeo por contexto).

### Execução no CI

O workflow `.github/workflows/robot-tests.yml` roda em eventos `push` e `pull_request` para os branches `main` e `master`. A pipeline utiliza **execução paralela por matrix:** dois jobs independentes rodam ao mesmo tempo — um executa `tests/login`, outro `tests/checkout`. Com `fail-fast: false`, a falha de uma suíte não interrompe a outra; ambas concluem e os artefatos das duas ficam disponíveis. No runner, a variável de ambiente `GITHUB_ACTIONS` está definida; o `base.resource` usa isso para definir `headless=${True}` no `New Browser`, então os testes rodam sem interface gráfica. O restante do fluxo (abertura/fechamento de browser, gravação de vídeo, screenshot em falha) é o mesmo da execução local.

### Geração de logs e relatórios

- O Robot Framework gera **log.html**, **report.html** e **output.xml** no diretório indicado por `-d results`.  
- O **log.html** inclui cada keyword executada, argumentos e resultados; quando a keyword de falha (`Capturar screenshot em falha`) é executada, o path da imagem fica associado ao log e o Robot pode exibir o screenshot no relatório.  
- **report.html** traz o resumo por suite e por teste (pass/fail, tempo).  
- **output.xml** é o formato padrão para integrações (parsers, ferramentas externas).

### Screenshots automáticos

- A Browser Library é importada em `base.resource` com `run_on_failure=Capturar screenshot em falha`.  
- Quando um keyword da Browser Library falha, o Robot dispara a keyword **Capturar screenshot em falha**, que cria `results/screenshots` (se não existir), tira um screenshot da página inteira (`fullPage=True`) e salva em `results/screenshots/${TEST NAME}_FAILURE_SCREENSHOT`. O path retornado permite que o screenshot apareça vinculado no log.html.

### Gravação de vídeos

- No **Abrir Saucedemo**, antes de `New Context`, o projeto cria `results/videos` e monta um dicionário `recordVideo` com `dir=${OUTPUT_DIR}/videos`.  
- O **New Context** é chamado com `recordVideo=${record_video}` e viewport configurado. O Playwright grava o vídeo do contexto; ao fechar o browser (Teardown), o vídeo é salvo em `results/videos/` (formato .webm). Cada abertura de browser (cada teste) gera um vídeo correspondente.

---

## 5. Pipeline de Integração Contínua (CI)

### Quando a pipeline é executada

- Em **push** para os branches `main` ou `master`.  
- Em **pull_request** direcionado a esses branches.

Arquivo: `.github/workflows/robot-tests.yml`.

### Execução paralela (matrix)

A pipeline utiliza **strategy.matrix** com `suite: [ login, checkout ]`. O GitHub Actions cria **dois jobs em paralelo**, cada um com os mesmos passos, porém executando uma suíte diferente:

- **Job 1:** executa `robot -d results tests/login` e faz upload do artefato **robot-results-login**.  
- **Job 2:** executa `robot -d results tests/checkout` e faz upload do artefato **robot-results-checkout**.

Com **fail-fast: false**, se uma suíte falhar, a outra continua até o fim; o resultado de ambas fica visível na aba Actions. A execução paralela reduz o tempo total da pipeline em relação à execução sequencial das duas suítes em um único job.

### Etapas da pipeline (em cada job)

| Etapa | Ação |
|-------|------|
| Checkout | `actions/checkout@v4` — clona o repositório. |
| Set up Python | `actions/setup-python@v5` com `python-version: "3.11"`. |
| Install dependencies | `pip install .` (instala robotframework e robotframework-browser conforme `pyproject.toml`). |
| Initialize Robot Framework Browser | `rfbrowser init` — baixa/ajusta binários do Playwright para o ambiente do runner. |
| Run Robot Framework tests | `robot -d results tests/${{ matrix.suite }}` — executa apenas a suíte do job (login ou checkout) em modo headless. |
| Upload Robot results | `actions/upload-artifact@v4` com `name: robot-results-${{ matrix.suite }}` e `path: results`. |

### Geração e upload de artefatos

Cada job gera sua própria pasta **results/** contendo:

- **log.html**, **report.html**, **output.xml** da suíte executada  
- **screenshots/** (quando há falhas naquela suíte)  
- **videos/** (vídeos dos testes daquela suíte)  

O step “Upload Robot results” sobe a pasta `results` com nome **robot-results-login** ou **robot-results-checkout**, conforme o job. Na aba Actions do GitHub, o usuário pode baixar os dois artefatos separadamente e analisar relatórios, screenshots e vídeos de cada suíte.

---

## 6. Estrutura de Testes Automatizados

### Cenários cobertos

**Login (`tests/login/login.robot`):**

- LOGIN-01 — Login válido com usuário padrão (standard_user).  
- LOGIN-02 — Login com senha inválida (mensagem de credenciais inválidas).  
- LOGIN-03 — Login com usuário inválido (mensagem de credenciais inválidas).  
- LOGIN-04 — Login com usuário bloqueado (locked_out_user; mensagem de usuário bloqueado).  
- LOGIN-05 — Login com campos vazios (mensagem de usuário obrigatório).

**Checkout (`tests/checkout/checkout.robot`):**

- CHECKOUT-01 — Checkout de um produto com dados válidos; validação de resumo (subtotal, taxa, total) e mensagem de agradecimento.  
- CHECKOUT-02 — Checkout de dois produtos com dados válidos; validação do resumo para dois itens e conclusão.  
- CHECKOUT-03 — Tentativa de checkout sem primeiro nome; validação de mensagem de erro (First Name required).  
- CHECKOUT-04 — Tentativa de checkout sem sobrenome; validação de mensagem de erro (Last Name required).  
- CHECKOUT-05 — Tentativa de checkout sem CEP; validação de mensagem de erro (Postal Code required).  
- CHECKOUT-06 — Cancelar checkout na tela de overview (sem finalizar compra).

### Tipo de testes

- **Funcionais de UI:** fluxos completos de login e checkout, incluindo validações de mensagens de erro e de valores na tela (resumo do pedido).  
- **Positivos:** login correto, checkout com um e com dois produtos até a tela de agradecimento.  
- **Negativos:** login com credenciais inválidas, usuário bloqueado, campos vazios; checkout sem preencher primeiro nome, sobrenome ou CEP.  
- **Fluxo alternativo:** cancelamento do checkout no overview.

### Organização por suíte

- Uma suíte **Login** (5 testes) e uma suíte **Checkout** (6 testes). Total: 11 casos de teste.  
- Cada suíte tem seu próprio arquivo de dados (login_data / checkout_data) e seu arquivo de keywords (login_keywords / checkout_keywords). Os pages são compartilhados conforme o fluxo (checkout usa login, inventory, cart e as três páginas de checkout).

### Uso de keywords reutilizáveis

- Os testes são escritos apenas com chamadas a keywords em estilo BDD (ex.: “Dado que estou na página de login”, “Quando preencho os dados de checkout com campos vazios”).  
- Essas keywords estão nos arquivos `keywords/*.resource` e reutilizam as keywords dos `pages/*.resource` e do `base.resource`. Exemplos: “Dado que estou logado como usuário padrão” usa Abrir Saucedemo, preenchimento de login e “Deve estar na página de inventário”; “Então o resumo de valores para um produto deve estar correto” chama a keyword do `checkout_overview_page.resource` que lê subtotal, taxa e total e compara com as variáveis de `checkout_data.resource`.

---

## 7. Observabilidade e Debug

### Relatórios HTML do Robot Framework

- **report.html** — visão geral por suíte e por teste (status, tempo, documentação). Útil para acompanhamento rápido de pass/fail.  
- **log.html** — detalhamento de cada keyword executada, com argumentos e resultados. Permite identificar em qual passo ocorreu a falha e qual foi a mensagem de erro.

### Screenshots automáticos

- Em caso de falha de um keyword da Browser Library, a keyword **Capturar screenshot em falha** é executada e salva a imagem em `results/screenshots/` com nome vinculado ao teste. O path é associado ao log, permitindo visualizar a tela no momento da falha diretamente no log.html (conforme suporte do Robot Framework a arquivos de mídia no output dir).

### Vídeos das execuções

- Cada contexto de browser (cada teste que chama “Abrir Saucedemo”) tem gravação de vídeo habilitada. Os arquivos são gravados em `results/videos/` (formato .webm). Úteis para reproduzir visualmente o fluxo que levou a uma falha ou para revisão de comportamento.

### Logs de execução

- Além do log.html, o Robot gera **output.xml** com toda a execução em formato estruturado. O Playwright/Browser Library pode gerar também logs próprios (ex.: playwright-log.txt), dependendo da configuração do ambiente.

---

## 8. Benefícios da Automação

- **Confiabilidade:** os 11 cenários de login e checkout são executados de forma repetível, com mesmos dados e mesmas validações, reduzindo erros de execução manual.  
- **CI integrada:** cada push ou pull request dispara a execução no GitHub Actions; a equipe recebe feedback rápido sobre a qualidade dos fluxos críticos.  
- **Execução paralela no CI:** as suítes Login e Checkout rodam em jobs simultâneos, reduzindo o tempo total da pipeline sem alterar a lógica dos testes.  
- **Manutenção:** Page Objects e keywords centralizam localizadores e passos; alterações na aplicação são tratadas em poucos arquivos (pages/resources), sem espalhar mudanças em dezenas de linhas de teste.  
- **Escalabilidade:** a mesma arquitetura (pages + keywords + dados) permite adicionar novas suítes (ex.: mais fluxos ou mais cenários de checkout) reutilizando keywords e pages já existentes.  
- **Rastreabilidade:** relatórios, screenshots e vídeos ficam disponíveis no artefato do CI, facilitando análise de falhas e auditoria de execuções.

---

## 9. Possíveis Melhorias Futuras

Sugestões baseadas na estrutura atual do projeto:

- **Execução paralela:** já implementada via matrix no GitHub Actions (um job para `tests/login`, outro para `tests/checkout`). Para paralelismo dentro de uma mesma suíte, pode-se avaliar Pabot.  
- **Testes cross-browser:** hoje o browser é Chromium. Incluir execuções com Firefox e WebKit (suportados pela Browser Library) via variáveis ou jobs separados no workflow.  
- **Execução por tags:** adicionar tags nos testes (ex.: `smoke`, `regression`, `checkout`) e no CI rodar por tag (ex.: `robot -d results --include smoke tests`) para smoke rápido em todo PR e suíte completa em horário agendado.  
- **Dashboard de testes:** integrar o output.xml a ferramentas como Allure ou ReportPortal para histórico de execuções, tendências e métricas por suíte/teste.  
- **Gestão de testes:** vincular casos de teste a requisitos ou IDs em ferramentas de gestão (ex.: tags com ID do caso) e usar parsers do output.xml para reportar status por requisito ou plano de teste.

---

*Relatório gerado com base no código e na configuração do repositório atual. Todas as descrições referem-se a arquivos e comportamentos existentes no projeto.*
