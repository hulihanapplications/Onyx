class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
     t.column :name, :string
     t.column :parent_id, :integer, :default => 0
     t.column :description, :string
     t.column :created_at, :datetime
    end
    Category.create(:name => "General", :parent_id => 0, :description => "My Pictures")
    Category.create(:name => "Uncategorized", :parent_id => 0, :description => "Pictures that just don't belong anywhere.")
  end

  def self.down
    drop_table :categories
  end
end
