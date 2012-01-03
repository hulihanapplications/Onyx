class CreateHits < ActiveRecord::Migration
  def self.up
    create_table :hits do |t|
     t.column :image_id, :integer, :null => false
     t.column :hits, :integer, :default => 0
    end
  end

  def self.down
    drop_table :hits
  end
end
