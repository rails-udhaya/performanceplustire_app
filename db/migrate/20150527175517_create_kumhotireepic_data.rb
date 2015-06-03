class CreateKumhotireepicData < ActiveRecord::Migration
  def change
    create_table :kumhotireepic_data do |t|
      t.string :inventory_number, :quantity, :quantity_updated_type, :seller_cost, :dc_quantity
      t.timestamps
    end
  end
end





