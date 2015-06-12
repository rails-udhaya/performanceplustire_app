class CreateAtdonlineLists < ActiveRecord::Migration
  def change
    create_table :atdonline_lists do |t|
      t.string :category, :subcategory, :brand_name
      t.boolean :is_enabled , :default => false
      t.timestamps
    end
  end
end
