HireFire::Resource.configure do |config|
  config.dyno(:all_worker) do
    HireFire::Macro::Sidekiq.queue
  end
end