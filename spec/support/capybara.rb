require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.default_max_wait_time = Integer(ENV.fetch('CAPYBARA_MAX_WAIT_TIME', 5))
Capybara.save_path = File.expand_path('../../tmp/capybara', __dir__)

chrome_args = %w[
  disable-gpu
  no-sandbox
  window-size=1440,900
]

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  chrome_args.each { |arg| options.add_argument("--#{arg}") }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  chrome_args.each { |arg| options.add_argument("--#{arg}") }
  options.add_argument('--headless=new')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

selected_driver = ENV.fetch('CAPYBARA_DRIVER', ENV['HEADLESS'] == 'false' ? 'chrome' : 'chrome_headless').to_sym

Capybara.default_driver = selected_driver
Capybara.javascript_driver = selected_driver
Capybara.server = :puma, { Silent: true }

base_url = ENV['APP_HOST']
Capybara.app_host = base_url unless base_url.to_s.empty?
Capybara.run_server = base_url.to_s.empty?

RSpec.configure do |config|
  config.after(type: :system) do |example|
    next unless example.exception

    timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
    filename = "#{example.full_description.gsub(/[^a-zA-Z0-9]+/, '-').downcase}-#{timestamp}.png"

    save_screenshot(File.join(Capybara.save_path, filename))
  end
end
