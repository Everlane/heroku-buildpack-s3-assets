require 'rspec'

$LOAD_PATH.push File.join(__dir__, '..', 'lib')

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
    mocks.yield_receiver_to_any_instance_implementation_blocks = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect, :should]
  end
end
