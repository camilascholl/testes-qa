# System Tests — Guia Completo

## Visao Geral

Os system tests automatizam fluxos reais do usuario no browser, validando que as funcionalidades
funcionam de ponta a ponta. Usamos **RSpec** como framework de testes e **Capybara** para controlar
o Chrome (visivel ou headless).

### Stack de testes

| Ferramenta | Funcao |
|------------|--------|
| RSpec | Framework de testes (estrutura, assertions, hooks) |
| Capybara | Simula interacoes do usuario no browser (clicar, preencher, navegar) |
| Selenium WebDriver | Conecta o Capybara ao Chrome |
| DatabaseCleaner | Desabilitado — usamos banco de bootstrap com dados pre-carregados |
| FactoryBot | Disponivel mas nao utilizado nos system tests (dados vem do bootstrap) |

---

## Estrutura de Arquivos

```text
spec/
  rails_helper.rb
  spec_helper.rb
  support/
    capybara.rb
    authentication_helper.rb
    database_cleaner.rb
    factory_bot.rb
  system/
    login_spec.rb
  factories/
  fixtures/files/
```

---

## Banco de Dados (Bootstrap)

Os testes **NAO criam dados do zero**. Usamos um banco pre-populado chamado `santedb_test` que
ja contem empresa, usuario, licenca e todos os dados necessarios.

### Como o banco e criado

```bash
DISABLE_SPRING=1 health_area=odonto bundle exec rails db_config:setup_test_db
```

Esse comando (definido em `lib/tasks/switch_database.rake`):
1. Copia `config/database_test.yml` para `config/database.yml`
2. Valida que o banco e `santedb_test`
3. Cria o banco se nao existir
4. Carrega o schema com `db:schema:load`
5. Roda os seeds com `db:seed`

### Dados disponiveis para testes

| Dado | Valor |
|------|-------|
| Email do usuario de teste | `teste@teste.com` |
| Senha | `Frm91084852@` |

### Importante

- O DatabaseCleaner esta **desabilitado** para nao apagar os dados do bootstrap
- Se os testes criarem dados extras durante a execucao, eles permanecem no banco
- Para resetar o banco ao estado original, rode `db_config:setup_test_db` novamente

---

## Como Rodar os Testes

### Localmente

```bash
health_area=odonto HEADLESS=false bundle exec rspec spec/system/login_spec.rb
health_area=odonto bundle exec rspec spec/system/login_spec.rb
health_area=odonto bundle exec rspec spec/system/
health_area=odonto bundle exec rspec spec/system/login_spec.rb:18
```

### No CI (GitHub Actions)

Os testes rodam automaticamente a cada push em um PR aberto contra `develop`.
O workflow esperado fica em `.github/workflows/system_tests.yml`.

### Testando o CI localmente com act

```bash
act -W .github/workflows/system_tests.yml --secret-file .secrets
```

Arquivo `.secrets`:

```text
RAILS_MASTER_KEY=<valor>
GH_PAT=<valor>
DISCORD_WEBHOOK=<url do webhook>
```

---

## Como o Capybara Funciona

O Capybara controla o Chrome e simula acoes do usuario.

### Locators

| Metodo | Busca por | Exemplo |
|--------|-----------|---------|
| `find('#id')` | Seletor CSS | `find('#btn-submit-form-login')` |
| `find('.classe')` | Classe CSS | `find('.text-danger')` |
| `fill_in 'name'` | name, id ou label | `fill_in 'user_email', with: 'x@y.com'` |
| `click_button` | texto, id ou value | `click_button 'Acessar'` |
| `click_link` | texto ou id | `click_link 'Esqueci minha senha'` |

**Preferencia:** usar `id` > `data-*` > `class` > texto.

### Espera automatica

O Capybara tenta continuamente ate a condicao ser verdadeira ou o tempo limite estourar.

```ruby
find('#user_email')
expect(page).to have_content('Login e/ou senha invalidos')
expect(page).to have_current_path(root_path, wait: 10)
```

### Assertions comuns

```ruby
expect(page).to have_current_path('/home')
expect(page).to have_content('Bem-vindo')
expect(page).to have_css('#meu-elemento')
expect(page).not_to have_css('.erro')
expect(page).to have_button('Salvar', disabled: true)
```

---

## Como Criar um Novo Teste

```ruby
require 'rails_helper'

RSpec.describe 'Agendamento', type: :system do
  it 'cria um novo agendamento' do
    sign_in_via_form(email: 'teste@teste.com', password: 'Frm91084852@')
    expect(page).to have_current_path(root_path, wait: 10)
  end
end
```

Dicas:
- Prefira IDs nos seletores
- Nunca use `sleep`
- Um teste por fluxo
- Cada `it` deve ser independente
- Redirects no CI podem precisar de `wait: 10`

---

## Troubleshooting

### "Unable to find css #elemento"

- Confira o screenshot em `tmp/capybara/`
- Verifique se o banco tem os dados esperados
- Verifique se os assets foram compilados

### "expected /users/sign_in to equal /"

```ruby
expect(page).to have_current_path(root_path, wait: 15)
```

### "session not created: ChromeDriver only supports Chrome version X"

```bash
sudo rm /usr/bin/chromedriver
```

### "Sprockets::FileNotFound" no CI

Verifique se o workflow executa `yarn i` antes do `assets:precompile`.

### Dados sumiram do banco

Verifique se `spec/support/database_cleaner.rb` continua sem hooks de limpeza.
