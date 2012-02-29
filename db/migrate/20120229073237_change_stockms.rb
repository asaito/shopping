class ChangeStockms < ActiveRecord::Migration
  def self.up
    change_column :stockms, :shopcode, :string, :null => false
    change_column :stockms, :stockcode, :string, :null => false
    change_column :stockms, :stockname, :string, :null => false
  end

  def self.down
  end
end
