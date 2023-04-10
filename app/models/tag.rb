class Tag < ApplicationRecord
    has_many :tag_maps, dependent: :destroy, foreign_key: 'tag_id'
    has_many :extag_maps, dependent: :destroy, foreign_key: 'tag_id'
    has_many :tomorecipes, through: :tag_maps
    has_many :external_sites, through: :extag_maps
end
