class ExternalSite < ApplicationRecord
    has_many :like2s, dependent: :destroy
    has_many :like2ed_users, through: :like2s, source: :user
    #belongs_to :tag_map
    #has_many :tag_maps, foreign_key: 'tag_id'
    
    has_many :extag_maps, dependent: :destroy
    has_many :tags, through: :extag_maps

    # belongs_to :tag
    # validates :tag_id1, presence: true
    # validates :tag_id2, presence: true
    # validates :tag_id3, presence: true
    # validates :tag_id4, presence: true
    # validates :tag_id5, presence: true
    # validates :tag_id6, presence: true
    # validates :tag_id7, presence: true
    # validates :tag_id8, presence: true
    # validates :tag_id9, presence: true
    # validates :tag_id10, presence: true
    # validates :tag_id11, presence: true
    # validates :tag_id12, presence: true
    # validates :tag_id13, presence: true
    # validates :tag_id14, presence: true
    # validates :tag_id15, presence: true
    # validates :tag_id16, presence: true
end
