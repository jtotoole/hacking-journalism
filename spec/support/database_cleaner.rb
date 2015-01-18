RSpec.configure do |config|

  # make sure all remnants are clead, every run
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transaction (fastest) for unit tests
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Use truncation for tests where setup and code execution are separate
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end