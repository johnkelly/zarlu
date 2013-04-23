class CompanySetting < ActiveRecord::Base
  belongs_to :subscriber

  attr_accessible :subscriber_id, :enabled
  validates_presence_of :subscriber_id
end

