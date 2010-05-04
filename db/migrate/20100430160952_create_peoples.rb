class CreatePeoples < ActiveRecord::Migration
  def self.up
    create_table :peoples do |t|
      t.string :title
      t.string :location
      t.string :group

      t.timestamps
    end
  end

  def self.down
    drop_table :peoples
  end
end
