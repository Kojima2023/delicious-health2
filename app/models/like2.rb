class Like2 < ApplicationRecord
  belongs_to :external_site
  belongs_to :user
  validates_uniqueness_of :external_site_id, scope: :user_id
end
