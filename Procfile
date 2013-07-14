web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
all_worker: bundle exec sidekiq -q default -q mailer -c 2
