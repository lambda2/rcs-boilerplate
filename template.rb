# generate(:scaffold, "person name:string")
# route "root to: 'people#index'"
# rake("db:migrate")
 


# ================== Prepare Gemfile ================

# Server stuff
gem 'responders', '~> 2.0'
gem 'has_scope'
gem 'inherited_resources'

gem 'unicorn'
gem 'classy_enum'

# Dev deploy & debug stuff
gem_group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
  gem 'capistrano-sidekiq'

  gem "letter_opener"
  gem 'meta_request'
  gem "better_errors"
end


# Auth stuff
if yes?("Would you like to install Devise?")
  gem "devise"
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
end

# Frontend
gem "haml"

# SCSS

gem 'bourbon'
gem 'neat'
gem 'bitters'
gem 'refills'

# ES6

gem "sprockets", '~> 3.0'
gem "sprockets-es6"
gem 'react-rails', '~> 1.0'
gem "bower-rails", "~> 0.9.2"

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end