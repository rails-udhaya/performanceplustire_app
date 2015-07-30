class ContilinkData < ActiveRecord::Base
  attr_accessible :article, :whs, :des_qty, :on_hand_avail_qty, :in_tran_available, :price_fet, :unit_fet, :weight, :article_description, :reference_id, :quantity_updated_type, :seller_cost, :dc_quantity
end
