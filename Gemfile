source 'https://rubygems.org'

ruby '2.1.1'

gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'spring', group: :development

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Database support
gem 'pg'

# Stylesheet support
gem 'bootstrap-sass'

# Static Pages
gem 'high_voltage'

gem 'haml'

gem 'stripe'

gem 'money'

gem 'comfortable_mexican_sofa', '~> 1.11.0'
gem 'rails_admin'

gem 'thin'

gem 'aws-sdk', '~> 1.43.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'minitest' # Just for shoulda-matchers to STFU: https://github.com/thoughtbot/shoulda-matchers/issues/408
  gem 'shoulda-matchers'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'capybara-screenshot'
  gem 'stripe-ruby-mock'
  gem 'webmock'
  gem 'vcr'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
