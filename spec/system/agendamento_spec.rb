require 'rails_helper'

RSpec.describe 'Agendamento', type: :system do
  it 'acessa a agenda e tira screenshot' do
    visit 'https://app.santeodonto.io/users/sign_in'

    #login
  find('input[type="email"]').set('')
find('input[type="password"]').set('')

 find('#btn-submit-form-login', wait: 10).click

    # sair da tela
    expect(page).to have_no_current_path('/users/sign_in', wait: 15)

save_and_open_screenshot

if page.has_css?('.swal2-popup, .modal', wait: 5)
  find('button.swal2-close, .modal .close', wait: 5).click
end

# 👉 esperar e clicar no alerta
within('.swal2-popup') do
  find('button.swal2-cancel', text: 'Deixar para depois', wait: 10).click
end

save_and_open_screenshot

    # clicar no livro
    find('a.icone-nav[href="/appointment_by_chair"]', wait: 10).click

    # verifica se entrou na agenda
    expect(page).to have_current_path('/appointment_by_chair', wait: 10)

    if page.has_css?('.swal2-popup', wait: 5)
  find('button.swal2-cancel', text: 'Deixar para depois').click
end
    
    save_and_open_screenshot
  end
end