class CreateContilinkData < ActiveRecord::Migration
  def change
    create_table :contilink_data do |t|
      t.string :article, :whs, :des_qty, :on_hand_avail_qty, :in_tran_available, :price_fet, :unit_fet, :weight, :reference_id, :quantity_updated_type, :seller_cost, :dc_quantity
      t.text :article_description
      t.timestamps
    end
  end
end


 
	

	
	
	
	

