
name = ask("What's the name of this awesome app ?")
name_underscore = name.underscore
description = ask("What's the purpose of it ? (short description)")
url = ask("Website url")
repo_url = ask("Repo url")


after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end