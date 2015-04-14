class Business < ActiveRecord::Base
  MAX_SLUG_LENGTH = 100

  belongs_to :owner, foreign_key: "user_id", class_name: "User"
  has_many :waitlist
  belongs_to :current_waitlist, foreign_key: "current_waitlist_id", :class_name => "Waitlist"

  validates_presence_of :owner, :name

  before_save {
    unless self.slug
      friendly_url = self.name.parameterize[0..MAX_SLUG_LENGTH - 1]
      self.slug = get_unique_slug(friendly_url)
    end
  }

  def toggle_open_close
    self.open = !self.open
    self.save
  end

  def current_waitlist_with_initialize
    if self.open
      current_waitlist_without_initialize || create_waitlist
    else
      self.current_waitlist = nil
      self.save
      return nil
    end
  end

  alias_method_chain :current_waitlist, :initialize

  private
    def create_waitlist
      self.current_waitlist = Waitlist.create(business_id: self.id)
      self.save
      return self.current_waitlist
    end

    def get_unique_slug(slug)
      slugs = Business.where("slug LIKE ?", "#{slug}%").pluck(:slug)
      if slugs.empty?
        slug
      else
        largest_number = slugs.map do |s|
          parts = s.gsub(slug, '').split('-')
          if parts.first.present?
            num = parts.first.to_i
          else
            num = parts[1].to_i
          end
        end.sort.last

        largest_number += 1
        slug + "-#{largest_number}"
      end
    end
end