class CreateUsers < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :username, :string
      t.column :password_hash, :string
      t.column :salt, :string
      t.column :phone_number, :string
      t.column :created_at, :datetime#this will get populated automatically  
      t.column :updated_at, :datetime#this will get populated automatically  
      t.column :description, :string
    end
   #-----Insert Data into table----------------
    User.create(:first_name => "John", :last_name => "Doe", :username => "admin", :password => "admin", :description => "I am a cool person!")
  end 

  def self.down
    drop_table :users
  end
end
