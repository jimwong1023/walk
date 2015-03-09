class User < ActiveRecord::Base
  attr_accessor :waiting

  has_secure_password :validations => false
  validates :email, uniqueness: true, 
    unless: Proc.new { |user| user.waiting }
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
    unless: Proc.new { |user| user.waiting }
  validates_presence_of :email, 
    unless: Proc.new { |user| user.waiting }
  validates_presence_of :first_name, :last_name
  validates :password, length: { minimum: 6 }, 
    unless: Proc.new { |user| user.waiting }
  validate :phone_number_format

  before_save { self.email = email.downcase if email }

  has_many :businesses
  has_many :entries

  def phone_number_format
    if phone_number
      n = phone_number.gsub(/[^0-9]/, "")
      if n.length != 10
        errors.add(:phone_number, "must be valid 10 digit format")
      end
    end 
  end
end