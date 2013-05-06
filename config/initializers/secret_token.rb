# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if Rails.env.production?
  # heroku set credentials from ENV hash
  RAILS_SECRET_TOKEN = ENV['RAILS_SECRET_TOKEN']
else
  # get credentials from YML file
  token_yaml_file = YAML.load_file Rails.root.join("config/secret_token.yml")
  RAILS_SECRET_TOKEN = token_yaml_file["rails_secret_token"]
end

Zarlu::Application.config.secret_token = RAILS_SECRET_TOKEN
