class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  validates_presence_of :user_id, :trackable_id

  scope :lifo, -> { order("created_at desc") }

  def to_partial_path
    "activities/#{trackable_type.underscore}s/#{action}"
  end
end
