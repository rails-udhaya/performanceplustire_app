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
