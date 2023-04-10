class CreateLike2s < ActiveRecord::Migration[6.1]
  def change
    create_table :like2s do |t|
      t.references :external_site, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
