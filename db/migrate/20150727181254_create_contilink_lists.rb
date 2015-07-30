class CreateContilinkLists < ActiveRecord::Migration
  def change
    create_table :contilink_lists do |t|
      t.string :brand_name, :brand_code, :category_name, :category_code, :product_line_name, :product_line_code
      t.boolean :is_enabled , :default => false
      t.timestamps
    end
  end
end
