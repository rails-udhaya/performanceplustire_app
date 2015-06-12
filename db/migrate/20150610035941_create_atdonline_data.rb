class CreateAtdonlineData < ActiveRecord::Migration
  def change
    create_table :atdonline_data do |t|
      t.string :size, :description, :supplier, :load_speed, :mileage_warranty, :sidewall, :local_dc, :local, :cost    
      t.timestamps
    end
  end
end
