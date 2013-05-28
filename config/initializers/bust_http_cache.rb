#Expire all caches (fragment and etag) when code changes
if Rails.env.production?
  heroku = Heroku::API.new(api_key: ENV["HEROKU_API_KEY"])
  release_version = heroku.get_releases(ENV["HEROKU_APP_NAME"]).body.last["name"]
  ENV['RAILS_CACHE_ID'] = release_version
end
