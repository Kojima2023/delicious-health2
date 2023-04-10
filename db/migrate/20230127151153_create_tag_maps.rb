class CreateTagMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_maps do |t|
      t.references :tomorecipe, null: true, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      # t.references :external_site, null: true, foreign_key: true
      
      # t.references :tomorecipe, foreign_key: true
      # t.references :tag, foreign_key: true
      # t.references :external_site, foreign_key: true

      t.timestamps
    end
  end
end
