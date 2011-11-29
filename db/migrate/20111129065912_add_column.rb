class AddColumn < ActiveRecord::Migration
  def self.up
    add_column :mallshopms, :pointenableflg, :integer
    remove_column :mallshopms, :initdatetime
  end

  def self.down
  end
end
