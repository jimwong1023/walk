class Waitlist < ActiveRecord::Base
  belongs_to :business
  has_many :entries

  validates_presence_of :business
end