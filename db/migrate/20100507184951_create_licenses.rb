class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table :licenses do |t|
      t.string :ls_id , :null => false 
      t.string :user_id , :null => false
      t.string :domain , :null => false
      t.text :description, :null => false
      t.string :is_source , :null => false
      t.string :source1 , :null => false
      t.string :source2 
      t.string :source3  
      t.string :source4  
      t.string :source5 
      t.string :source6
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
