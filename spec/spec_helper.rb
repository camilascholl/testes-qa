require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :selenium_chrome

# ✅ IMPORTANTE (espera automática)
Capybara.default_max_wait_time = 10

# ✅ IMPORTANTE (seu sistema externo)
Capybara.app_host = 'https://app.santeodonto.io'