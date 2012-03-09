class CreateCustattrms < ActiveRecord::Migration
  def self.up
    create_table :custattrms do |t|
      t.integer :attrflag
      t.string :attrname
      t.integer :disporder

      t.timestamps
    end
  end

  def self.down
    drop_table :custattrms
  end
end
