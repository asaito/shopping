class CreateMemberlevelms < ActiveRecord::Migration
  def self.up
    create_table :memberlevelms do |t|
      t.integer :memberlevel
      t.string :memberlevelname
      t.integer :discountrate

      t.timestamps
    end
  end

  def self.down
    drop_table :memberlevelms
  end
end
