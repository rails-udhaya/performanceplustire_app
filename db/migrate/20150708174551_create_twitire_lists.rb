class CreateTwitireLists < ActiveRecord::Migration
  def change
    create_table :twitire_lists do |t|
      t.string :category
      t.text :image_url
      t.boolean :is_enabled , :default => false
      t.timestamps
    end
  end
end
