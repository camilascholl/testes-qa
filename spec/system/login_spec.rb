require 'rails_helper'

RSpec.describe 'Login do sistema', type: :system do
  it 'faz login e pausa no popup para inspeção' do
    visit '/users/sign_in'

    # espera carregar
    expect(page).to have_selector('#btn-submit-form-login', wait: 10)

  
    email = find('input[type="email"]', wait: 10)
    email.set('')
    email.send_keys(ENV['EMAIL'])

    senha = find('input[type="password"]')
    senha.set('')
    senha.send_keys(ENV['PASSWORD'])

  
    email.send_keys(:tab)

    find('#btn-submit-form-login', wait: 10).click


    expect(page).to have_no_current_path('/users/sign_in', wait: 15)

      require 'byebug'
    byebug

    save_and_open_page
  
  end
end