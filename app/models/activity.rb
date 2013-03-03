class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  validates_presence_of :user_id, :trackable_id

  attr_accessible :action, :trackable
end
