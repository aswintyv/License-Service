class CreateMashups < ActiveRecord::Migration
  def self.up
    create_table :mashups do |t|
      t.column :key, :string
      t.column :url, :string
      t.column :users_id, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :mashups
  end
end
