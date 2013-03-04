web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
all_worker: bundle exec sidekiq -q list -q all -q queues -q here
