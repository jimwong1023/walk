class Business < ActiveRecord::Base
  belongs_to :owner, foreign_key: "user_id", class_name: "User"
  has_one :waitlist

  validates_presence_of :owner, :name
end