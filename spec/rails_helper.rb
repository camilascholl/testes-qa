require File.expand_path('spec_helper', __dir__)

begin
  require 'capybara/rspec'
  require_relative 'support/capybara'
rescue LoadError
  warn 'Capybara nao esta disponivel. Instale as gems para executar system specs.'
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each do |file|
  require file
end

RSpec.configure do |config|
  if defined?(ActiveRecord::Migration)
    begin
      ActiveRecord::Migration.maintain_test_schema!
    rescue StandardError => e
      warn "Nao foi possivel manter o schema de teste atualizado: #{e.message}"
    end
  end

  if defined?(FactoryBot)
    config.include FactoryBot::Syntax::Methods
  end

  if defined?(Devise) && defined?(Devise::Test::IntegrationHelpers)
    config.include Devise::Test::IntegrationHelpers, type: :system
  end

  config.infer_spec_type_from_file_location! if config.respond_to?(:infer_spec_type_from_file_location!)
  config.filter_rails_from_backtrace! if config.respond_to?(:filter_rails_from_backtrace!)
end

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end