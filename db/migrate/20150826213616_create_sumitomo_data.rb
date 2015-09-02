class CreateSumitomoData < ActiveRecord::Migration
  def change
    create_table :sumitomo_data do |t|
      t.string :inventory_number, :quantity, :quantity_updated_type, :seller_cost, :dc_quantity
      t.timestamps
      t.timestamps
    end
  end
end
