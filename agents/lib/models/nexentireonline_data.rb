class NexentireonlineData < ActiveRecord::Base
  attr_accessible :material, :material_desc, :load, :stock_ot, :stock_at, :stock_total, :water_ot, :water_at, :water_total, :arrival_ot, :arrival_at, :arrival_total, :inventory_number, :quantity, :quantity_updated_type, :seller_cost, :dc_quantity
end

