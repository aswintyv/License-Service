class CreateLicenseevals < ActiveRecord::Migration
  def self.up
    create_table :licenseevals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :licenseevals
  end
end
