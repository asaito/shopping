class RemoveColumnCustaddress < ActiveRecord::Migration
  def self.up
    remove_column :custaddresses, :addresscode
  end

  def self.down
  end
end
