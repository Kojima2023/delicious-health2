class TagMap < ApplicationRecord
  belongs_to :tomorecipe
  belongs_to :tag
  # belongs_to :external_site

  # validates :tomorecipe_id, presence: true
  validates :tag_id, presence: true
  # validates :external_site_id, presence: true
end
