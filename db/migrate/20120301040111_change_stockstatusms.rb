class ChangeStockstatusms < ActiveRecord::Migration
  def self.up
    change_column :stockstatusms, :stockstatuscode, :integer, :null => false
    change_column :stockstatusms, :amountoflessstock, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
