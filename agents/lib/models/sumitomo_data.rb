class SumitomoData < ActiveRecord::Base
  attr_accessible :inventory_number, :quantity, :quantity_updated_type, :seller_cost, :dc_quantity
end
