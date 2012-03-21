class ChagerOrders < ActiveRecord::Migration
  def self.up
change_column :orders, :custcompanyflg, :integer, :default => 0, :null => false
change_column :orders, :custname, :string, :null => false
change_column :orders, :custpronname, :string, :null => false
change_column :orders, :orderaddressee, :string, :null => false
change_column :orders, :postcode1, :string, :null => false
change_column :orders, :postcode2, :string, :null => false
change_column :orders, :address2, :string, :null => false
change_column :orders, :initdatetime, :timestamp, :null => false
change_column :orders, :updatedatetime, :timestamp, :null => false
change_column :orders, :paymentflg, :integer, :default => 0, :null => false
change_column :orders, :fee, :integer, :default => 0, :null => false
change_column :orders, :sendmailflg, :integer, :default => 0, :null => false
change_column :orders, :address1, :string, :null => false
change_column :orders, :sumofdiscount, :integer, :default => 0, :null => false
change_column :orders, :sumbypoint, :integer, :default => 0, :null => false
change_column :orders, :taxrate, :integer, :default => 0, :null => false
change_column :orders, :status, :integer, :default => 0, :null => false
change_column :orders, :feetaxflg, :integer, :default => 1, :null => false
change_column :orders, :custid, :integer, :null => false
change_column :orders, :receiptmailflg, :integer, :default => 0, :null => false
change_column :orders, :pointenableflg, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
