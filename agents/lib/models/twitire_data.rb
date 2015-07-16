class TwitireData < ActiveRecord::Base
  attr_accessible :inventory_number, :quantity, :dc_quantity, :seller_cost, :manufacturer, :mpn, :attribute1_name, :attribute1_value, :attribute2_name, :classification, :dc_code, :attribute3_name, :attribute3_value, :attribute4_name, :attribute4_value, :quantity_update, :attribute2_value, :labels_for
end
