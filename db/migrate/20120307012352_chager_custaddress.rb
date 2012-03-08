class ChagerCustaddress < ActiveRecord::Migration
  def self.up
    change_column :custaddresses, :addresscode, :integer, :null => false
    change_column :custaddresses, :custcompanyflg, :integer, :default => 0, :null => false
    change_column :custaddresses, :deliveryname, :string, :null => false
    change_column :custaddresses, :deliveryaddressee, :string, :null => false
    change_column :custaddresses, :postcode1, :string, :null => false
    change_column :custaddresses, :postcode2, :string, :null => false
    change_column :custaddresses, :address1, :string, :null => false
    change_column :custaddresses, :address2, :string, :null => false
    change_column :custaddresses, :sendmailflg, :integer, :default => 0, :null => false
    change_column :custaddresses, :daysbeforehand, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
