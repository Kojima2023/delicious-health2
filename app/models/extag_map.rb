class ExtagMap < ApplicationRecord
  belongs_to :external_site
  belongs_to :tag
  
  validates :tag_id, presence: true
  # validates :external_site_id, presence: true
end
