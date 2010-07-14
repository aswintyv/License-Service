class CreateMashupFiles < ActiveRecord::Migration
  def self.up
    create_table :mashup_files do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mashup_files
  end
end
