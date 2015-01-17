source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.1.4'

# Use postgresql as the database for Active Record
# gem 'pg'
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# build xml apis
gem 'builder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# for cross domain sharing
gem 'rack-cors', :require => 'rack/cors'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# For "spring"-loading rspec
gem "spring-commands-rspec", group: :development

# Use Haml format templates
gem "haml-rails"


# generic http requests
gem 'rest-client'
# for parsing xml
gem 'nokogiri'
# for converting urls to safe
gem 'htmlentities'

# gem "devise"
# gem 'activeadmin', github: 'gregbell/active_admin'


# Keep people out unless they have the secret code
# gem "beta_bouncer", git: 'https://bitbucket.org/hln-product/beta_bouncer.git'

# 12 Factor gem for Heroku
gem "rails_12factor", group: :production

group :production do
  gem "unicorn"
end

group :development, :test do
  # Use rspec-style tests
  gem 'rspec-rails'

  # For easily creating ActiveRecord records
  gem 'factory_girl_rails'

  # For debugging
  gem 'pry-byebug'
  gem 'rb-readline'

  # So useful info doesn't get pushed down in the logs by the asset request info
  gem 'quiet_assets'

  # For sharing credit on tests
  gem 'git-pairing'

  # Easily populate environment variables in development mode
  gem 'dotenv-rails'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'excon', '<0.39.0'
  # For testing the full stack
  gem 'capybara', '~> 2.2.1'
  gem 'capybara-webkit', '~> 1.1.0'
  # To controll a browser
  gem 'selenium-webdriver'

  # For removing remanants of test records
  gem 'database_cleaner'

  # Use gem minitest instead of older packaged-with-Ruby minitest
  gem 'minitest'

  # For fake data
  gem 'ffaker', :github =>  'johnnymugs/ffaker'

  # For fancy Active Record matchers
  gem 'shoulda-matchers'

  # For opening save_and_open_page automatically
  gem 'launchy'
end



