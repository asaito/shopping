class ChangePointenableflgColumn < ActiveRecord::Migration
  def self.up
    change_column :mallshopms, :pointenableflg, :integer, :default => 0, :null => :false
  end

  def self.down
  end
end
