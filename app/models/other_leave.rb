class OtherLeave < Leave
  belongs_to :user, touch: true

  validates_presence_of :type
end

