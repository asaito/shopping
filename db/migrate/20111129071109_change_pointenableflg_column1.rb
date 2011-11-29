class ChangePointenableflgColumn1 < ActiveRecord::Migration
  def self.up
    change_column :mallshopms, :pointenableflg, :integer, :null => :false, :default => 0

  end

  def self.down
  end
end
