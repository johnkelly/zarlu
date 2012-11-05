class User < ActiveRecord::Base
  belongs_to :subscriber

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscriber_id

  validates_presence_of :subscriber_id
end
