# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


%w(KU39 KU27 KU22 PA31 KH16 TA31 KR21 KR26 KL12 KL21 KL51 KL78 KL71 V710 KL33 KU36).each do |patt|
        if !KumhotireepicPattern.exists?(:pattern => patt)
                kumhotireepic_pattern = KumhotireepicPattern.create(:pattern => patt, :is_enabled => true)
                
        end
end	