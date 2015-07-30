# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


%w(KU39 KU27 KU22 PA31 KH16 TA31 KR21 KR26 KL12 KL21 KL51 KL78 KL71 V710 KL33 KU36 TA11 KH25 AT51).each do |patt|
        if !KumhotireepicPattern.exists?(:pattern => patt)
                kumhotireepic_pattern = KumhotireepicPattern.create(:pattern => patt, :is_enabled => true)
                
        end
end	

lis_1=["BFGoodrich",		"Blacklion",		"Bluestar",		"Bridgestone",		"Capitol",		"Continental",		"Cooper",		"Dayton",		"Dean",		"Denman",		"Dick Cepek",		"Double Coin",		"Dunlop",		"Durun",		"Falken",		"Federal",		"Fierce",		"Firestone",		"Fuzion",		"General",		"Gislaved",		"Goodride",		"Goodyear",		"Gremax",		"Hankook",		"Hercules",		"Hi Run",		"Interco",		"Ironman",		"Jetzon",		"JK Tyre",		"Kelly",		"Kumho",		"Lanvigator",		"Long March",		"Mastercraft	",		"Maxtrek",		"Michelin",		"Mickey Thompson",		"Misc",		"Nexen",		"Nitto",		"Nokian",		"Omni",		"Pirelli",		"Primewell",		"Private Label",		"Regul",		"Republic",		"Samson",		"Specialty",		"Suntek",		"Toyo",		"TracMax",		"Uniroyal",		"Vogue",		"Westlake",		"Yokohama"]
lis_1.each do |l_1|
        if !AtdonlineList.exists?(:brand_name => l_1)
                create_atdonline_lists = AtdonlineList.create(:category => "tires",:subcategory => "passenger_and_light_truck", :brand_name => l_1, :is_enabled => true)
        end
end	


lis_2=[["Antares","http://new.tirelibrary.com/images/Manflogos/antares.png"],["Carlisle","http://new.tirelibrary.com/images/Manflogos/CARLISLE.png"],["Doublecoin","http://new.tirelibrary.com/images/Manflogos/DOUBLECOIN.png"],["Duraturn","http://new.tirelibrary.com/images/Manflogos/Duraturn.png"],["Durun","http://new.tirelibrary.com/images/Manflogos/DURUN.png"],["Federal","http://new.tirelibrary.com/images/Manflogos/FEDERAL.png"],["GTRadial","http://new.tirelibrary.com/images/Manflogos/GTRADIAL.png"],["Hankook","http://new.tirelibrary.com/images/Manflogos/HANKOOK.png"],["Hoosier","http://new.tirelibrary.com/images/Manflogos/HOOSIER.png"],["Nexen","http://new.tirelibrary.com/images/Manflogos/NEXEN.png"],["Prometer","http://new.tirelibrary.com/images/Manflogos/PROMETER.png"],["Radar","http://new.tirelibrary.com/images/Manflogos/RADAR.png"],["Sentinel","http://new.tirelibrary.com/images/Manflogos/sentinel.png"],["Starfire","http://new.tirelibrary.com/images/Manflogos/STARFIRE.png"],["Venezia","http://new.tirelibrary.com/images/Manflogos/Venezia.png"],["Yokohama","http://new.tirelibrary.com/images/Manflogos/YOKOHAMA.png"]]
lis_2.each do |l|
category=""		
image_url=""		
category=l[0]
image_url =l[1]
		     if !TwitireList.exists?(:category => category)
                create_twitire_lists = TwitireList.create(:category => "#{category}",:image_url => "#{image_url}", :is_enabled => true)
        end
end


lis_3=[["Continental","10","Passenger","PS","PureContact","CAF"],
["Continental","10","Passenger","PS","TrueContact","CYJ"],
["Continental","10","Passenger","PS","ExtremeContact DWS06","CYP"],
["Continental","10","Passenger","PS","ExtremeContact DW","C0V"],
["Continental","10","Passenger","PS","ContiSportContact 5P","C44"],
["Continental","10","Passenger","PS","ContiProContact","CCH"],
["Continental","10","Passenger","PS","TouringContact CV95","C7J"],
["Continental","10","Passenger","PS","ContiSportContact 3","CIL"],
["Continental","10","Passenger","PS","ContiSportContact 2","CAV"],
["Continental","10","Passenger","PS","ContiSportContact 5","C1F"],
["Continental","10","Passenger","PS","Conti Sport Contact","C22"],
["Continental","10","Passenger","PS","ProContactTX","C9V"],
["Continental","10","Passenger","PS","CrossContact LX Sport","CA0"],
["Continental","10","Passenger","PS","ProContact GX","C9U"],
["Continental","10","Passenger","PS","ContiPremiumContact2","CWF"],
["Continental","10","Passenger","PS","WinterContact TS810S","CWC"],
["Continental","10","Passenger","PS","WinterContact TS810","CWA"],
["Continental","10","Passenger","PS","ContiWinterContact TS830 P","CF9"],
["Continental","10","Passenger","PS","ContiSportContact 5P","C44"],
["Continental","10","Passenger","PS","Conti 4x4 SportCont ","CC2"],
["Continental","10","Light Truck ","LT","CrossContact UHP","CB2"],
["Continental","10","Light Truck ","LT","CrossContact LX","CA4"],
["Continental","10","Light Truck ","LT","CrossContact LX20","C78"],
["Continental","10","Light Truck ","LT","Conti 4x4 Contact","CAO"],
["Continental","10","Light Truck ","LT","VancoFourSeason","CCG"],
["Continental","10","Light Truck ","LT","CrossContact UHP","CB2"],
["Continental","10","Light Truck ","LT","CrossContact LX20","C78"],
["Continental","10","Light Truck ","LT","ContiTrac","CBA"],
["Continental","10","Light Truck ","LT","ContiCrossContact-Winter","CJI"],
["Continental","10","Light Truck ","LT","ContiTrac TR","CAT"],
["Continental","10","Light Truck ","LT","Contitrac SUV","C9P"],
["Continental","10","Light Truck ","LT","Conti 4x4 Wint Cont","CAD"],
["Continental","10","Light Truck ","LT","Conti 4X4 Contact","CAO"]]

lis_3.each do |l|
brand_name=""
brand_code= ""
category_name=""
category_code= ""
product_line_name = "" 
product_line_code = ""

brand_name=l[0]
brand_code= l[1]
category_name=l[2]
category_code= l[3]
product_line_name = l[4]
product_line_code = l[5]

		     if !ContilinkList.exists?(:product_line_code => product_line_code)
                create_contilink_lists = ContilinkList.create(:brand_name => "#{brand_name}",:brand_code => "#{brand_code}",:category_name => "#{category_name}",:category_code => "#{category_code}",:product_line_name => "#{product_line_name}",:product_line_code => "#{product_line_code}", :is_enabled => true)
        end
end


