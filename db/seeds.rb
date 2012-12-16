require 'build_models'

case Rails.env.development? || Rails.env.test?
when true
  ActionMailer::Base.delivery_method = :test

  tables = ActiveRecord::Base.connection.tables.sort
  tables.delete("schema_migrations")
  tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table}")
    ActiveRecord::Base.connection.reset_pk_sequence!(table)
  end
  instance_eval &BuildModels.builder

  tables.each do |table|
    model = table.classify.constantize
    puts "%3d %s" % [model.count, model.name]
  end
else
  puts "Reseed data failed"
end
