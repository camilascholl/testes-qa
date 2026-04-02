require 'rails_helper'

RSpec.describe 'Login do sistema', type: :system do
  it "faz login com sucesso" do
  visit 'https://app.santeodonto.io/users/sign_in'

  save_and_open_screenshot 

  find('input[type="email"]').set('')
find('input[type="password"]').set('')

  click_button 'Acessar'

  expect(page).to have_content('Bom dia, Camila', wait: 5)
end
end
