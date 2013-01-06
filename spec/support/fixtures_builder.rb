require 'build_models'

FixtureBuilder.configure do |config|
  config.files_to_check += Dir[*%w[spec/support/fixture_builder.rb lib/build_models.rb]]
  config.record_name_fields << "email"
  config.factory do
    instance_eval &BuildModels.builder
  end
end
