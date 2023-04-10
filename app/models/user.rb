class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  mount_uploader :image, ImageUploader
  
  has_many :tomorecipes, dependent: :destroy
  has_many :external_sites, dependent: :destroy
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }
  has_many :likes, dependent: :destroy
  has_many :like2s, dependent: :destroy
  has_many :liked_tomorecipes, through: :likes, source: :tomorecipe
  has_many :like2ed_external_sites, through: :like2s, source: :external_site

  def already_liked?(tomorecipe)
    self.likes.exists?(tomorecipe_id: tomorecipe.id)
  end

  def already_like2ed?(external_site)
    self.like2s.exists?(external_site_id: external_site.id)
  end
  
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
