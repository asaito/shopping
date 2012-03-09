class ChangeCustattrms < ActiveRecord::Migration
  def self.up
    change_column :custattrms, :attrflag, :integer, :null => false
    change_column :custattrms, :attrname, :string, :null => false
    change_column :custattrms, :disporder, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
