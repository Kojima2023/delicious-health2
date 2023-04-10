class CreateExternalSites < ActiveRecord::Migration[6.1]
  def change
    create_table :external_sites do |t|
      t.string :title
      t.string :img_url
      t.string :recipe_url
      t.string :key

      t.timestamps
    end
  end
end
