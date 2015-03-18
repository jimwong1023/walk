class Business < ActiveRecord::Base
  belongs_to :owner, foreign_key: "user_id", class_name: "User"
  has_many :waitlist
  belongs_to :current_waitlist, foreign_key: "current_waitlist_id", :class_name => "Waitlist"

  validates_presence_of :owner, :name
end