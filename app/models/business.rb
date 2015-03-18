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

  private
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