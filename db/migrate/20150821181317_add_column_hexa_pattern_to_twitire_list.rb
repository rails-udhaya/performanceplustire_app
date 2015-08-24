class AddColumnHexaPatternToTwitireList < ActiveRecord::Migration
  def change
    add_column :twitire_lists, :hexa_pattern, :string
  end
end
