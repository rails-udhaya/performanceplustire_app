class CreateTwitireData < ActiveRecord::Migration
  def change
    create_table :twitire_data do |t|
      t.string :inventory_number, :quantity, :dc_quantity, :seller_cost, :manufacturer, :mpn, :attribute1_name, :attribute1_value, :attribute2_name, :classification, :dc_code, :attribute3_name, :attribute3_value, :attribute4_name, :attribute4_value, :quantity_update, :labels_for
      t.text :attribute2_value
      t.timestamps
    end
  end
end
