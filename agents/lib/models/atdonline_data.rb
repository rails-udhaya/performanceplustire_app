class AtdonlineData < ActiveRecord::Base
  attr_accessible :size, :description, :supplier, :load_speed, :mileage_warranty, :sidewall, :local_dc, :local, :cost    
end
