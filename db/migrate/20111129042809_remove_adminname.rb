class RemoveAdminname < ActiveRecord::Migration
  def self.up
    remove_column :mallshopms, :malladminname
  end

  def self.down
  end
end
