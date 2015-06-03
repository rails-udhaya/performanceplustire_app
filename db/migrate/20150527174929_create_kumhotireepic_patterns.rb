class CreateKumhotireepicPatterns < ActiveRecord::Migration
  def change
    create_table :kumhotireepic_patterns do |t|
      t.string :pattern
      t.boolean :is_enabled , :default => false
      t.timestamps
    end
  end
end
