source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.2.2"
gem "active_model_serializers"
gem "active_storage_validations", "0.9.8"
gem "bcrypt", "3.1.18"
gem "bootsnap", require: false
gem "bootstrap-icons-helper"
gem "bootstrap-sass", "3.4.1"
gem "cancancan", "~> 3.5"
gem "config"
gem "devise"
gem "faker", "2.21.0"
gem "figaro", "~> 1.2"
gem "font-awesome-sass"
gem "image_processing", "1.12.2"
gem "importmap-rails"
gem "jbuilder"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.5"
gem "sassc-rails", "2.1.2"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
  gem "simplecov"
  gem "simplecov-rcov"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "webdrivers"
end
