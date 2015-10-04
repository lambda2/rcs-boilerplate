
require 'net/http'

SOURCE_REPO = "https://raw.githubusercontent.com/lambda2/rcs-boilerplate/master/template/"

# $ find ./template -type f | grep -v ".DS_Store" | grep -v ".keep"
dir_list = [
"app/assets/stylesheets/base/",
"config/deploy/",
"config/unicorn/"
]

to_add = [
"app/assets/stylesheets/application.scss",
"app/assets/javascripts/application.js",
"app/assets/stylesheets/base/_base.scss",
"app/assets/stylesheets/base/_buttons.scss",
"app/assets/stylesheets/base/_fonts.scss",
"app/assets/stylesheets/base/_forms.scss",
"app/assets/stylesheets/base/_grid-settings.scss",
"app/assets/stylesheets/base/_helpers.scss",
"app/assets/stylesheets/base/_img.scss",
"app/assets/stylesheets/base/_lists.scss",
"app/assets/stylesheets/base/_mixins.scss",
"app/assets/stylesheets/base/_notifications.scss",
"app/assets/stylesheets/base/_reset.scss",
"app/assets/stylesheets/base/_tables.scss",
"app/assets/stylesheets/base/_typography.scss",
"app/assets/stylesheets/base/_variables.scss",
"app/views/layouts/_navbar.html.haml",
"app/views/layouts/application.html.haml",
"bower.json",
"Capfile",
"config/database.yml",
"config/deploy/production.rb",
"config/deploy.rb",
"config/environments/development.rb",
"config/environments/production.rb",
"config/environments/test.rb",
"config/unicorn/production.rb",
"Gemfile",
"get_db.sh",
"public/404.html",
"public/422.html",
"public/500.html",
"public/browserconfig.xml",
"public/manifest.json",
"public/robots.txt",
"README.md"
]

to_delete = [
"app/views/layouts/application.html.erb",
"app/assets/stylesheets/application.css",
"README.rdoc"
]

name = ask("What's the name of this awesome app ?")
name_underscore = name.underscore
description = ask("What's the purpose of it ? (short description)")
url = ask("Website url")
repo_url = ask("Repo url")


p destination_root

dir_list.each {|d| Dir.mkdir("#{destination_root}/#{d}") }

to_add.each do |file|
  f = Net::HTTP.get(URI("#{SOURCE_REPO}#{file}"))
  print "#{file}: #{f.length}\n"
  text = f
    .gsub("%NAME_UNDERSCORE", name_underscore)
    .gsub("%NAME", name)
    .gsub("%DESCRIPTION", description)
    .gsub("%REPO_URL", repo_url)
    .gsub("%URL", url)
  File.open("#{destination_root}/#{file}", 'w') { |file| file.write(text) }
end

to_delete.each do |file|
  run "rm #{file}"
end

after_bundle do

  rake "db:setup"

  # devise
  generate "devise:install"
  generate "devise", "User"

  # Bower
  rake "bower:install"

  rake "db:migrate"

  #react
  generate "react:install"

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end