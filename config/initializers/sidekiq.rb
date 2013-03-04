require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  if Rails.env.production?
    username == ENV['SIDEKIQ_USER'] && password == ENV['SIDKIQ_PASSWORD']
  else
    yaml_file = YAML.load_file Rails.root.join("config/sidekiq.yml")
    username == yaml_file["username"] && password == yaml_file["password"]
  end
end