source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.4"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "propshaft"
gem "inertia_rails", "~> 3.23"
gem "vite_rails", "~> 3.11"
gem "bcrypt", "~> 3.1"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "web-console"
  gem "foreman"
end

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubocop-rails-omakase", require: false
end
