class AddColumnCustaddress < ActiveRecord::Migration
  def self.up
    add_column :custaddresses, :custid, :integer, :null => false
  end

  def self.down
  end
end
