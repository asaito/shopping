class ChangeMemberlevelms < ActiveRecord::Migration
  def self.up
    change_column :memberlevelms, :memberlevel, :integer, :null => false
    change_column :memberlevelms, :memberlevelname, :string, :null => false
    change_column :memberlevelms, :discountrate, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
