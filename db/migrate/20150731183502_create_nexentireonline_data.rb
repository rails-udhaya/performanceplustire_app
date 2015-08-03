class CreateNexentireonlineData < ActiveRecord::Migration
  def change
    create_table :nexentireonline_data do |t|
   t.string :material, :load, :stock_ot, :stock_at, :stock_total, :water_ot, :water_at, :water_total, :arrival_ot, :arrival_at, :arrival_total, :inventory_number, :quantity, :quantity_updated_type, :seller_cost, :dc_quantity
      t.text :material_desc
      t.timestamps
    end
  end
end


