class Entry < ActiveRecord::Base
  belongs_to :waitlist
  belongs_to :user

  validates_presence_of :waitlist, :active, :first_name, :last_name
end