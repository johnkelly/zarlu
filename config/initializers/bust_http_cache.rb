#This is part of bust_rails_etags gem
if Rails.env.production?
  heroku = Heroku::API.new(api_key: ENV["HEROKU_API_KEY"])
  release_version = heroku.get_releases(ENV["HEROKU_APP_NAME"]).body.last["name"]
  ENV["ETAG_VERSION_ID"] = release_version
end
