RSpec.configure do |config|
  next unless defined?(FactoryBot)

  config.include FactoryBot::Syntax::Methods
end
