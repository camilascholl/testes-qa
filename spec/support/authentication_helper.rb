module AuthenticationHelper
  DEFAULT_LOGIN_EMAIL = 'teste@teste.com'.freeze
  DEFAULT_LOGIN_PASSWORD = 'Frm91084852@'.freeze
  LOGIN_PATH = '/users/sign_in'.freeze

  def sign_in_via_form(email: ENV.fetch('LOGIN_EMAIL', DEFAULT_LOGIN_EMAIL),
                       password: ENV.fetch('LOGIN_PASSWORD', DEFAULT_LOGIN_PASSWORD))
    raise ArgumentError, 'Defina um email valido para executar o teste de login.' if blank_value?(email)
    raise ArgumentError, 'Defina uma senha valida para executar o teste de login.' if blank_value?(password)

    visit LOGIN_PATH
    fill_login_field(email)
    fill_password_field(password)
    submit_login_form
  end

  private

  def fill_login_field(email)
    if page.has_css?('#user_email', wait: 1)
      find('#user_email').set(email)
    else
      fill_in 'Email', with: email
    end
  end

  def fill_password_field(password)
    if page.has_css?('#user_password', wait: 1)
      find('#user_password').set(password)
    else
      fill_in 'Senha', with: password
    end
  end

  def submit_login_form
    if page.has_css?('#btn-submit-form-login', wait: 1)
      find('#btn-submit-form-login').click
    else
      click_button 'Entrar'
    end
  end

  def blank_value?(value)
    value.nil? || value.strip.empty?
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :system
end
