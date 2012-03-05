class ChangeCusts < ActiveRecord::Migration
  def self.up
    change_column :custs, :memberlevelcode, :integer, :null => false
    change_column :custs, :custcompanyflg, :integer, :default => 0, :null => false
    change_column :custs, :custname, :string, :null => false
    change_column :custs, :custpronname, :string, :null => false
    change_column :custs, :email, :string, :null => false
    change_column :custs, :password, :string, :null => false
    change_column :custs, :postcode1, :string, :null => false
    change_column :custs, :postcode2, :string, :null => false
    change_column :custs, :address1, :string, :null => false
    change_column :custs, :address2, :string, :null => false
    change_column :custs, :sex, :integer, :default => 0, :null => false
    change_column :custs, :newmailflg, :integer, :default => 0, :null => false
    remove_column :custs, :custcode
  end

  def self.down
  end
end
