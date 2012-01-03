class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :name, :string
      t.column :image_id, :integer
      t.column :ip, :string
      t.column :comment, :text
      t.column :created_at, :datetime#this will get populated automatically
    end

    # add index 
    add_index :comments, :image_id
  end

  def self.down
    drop_table :comments
  end

end
