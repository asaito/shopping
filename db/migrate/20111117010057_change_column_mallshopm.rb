class ChangeColumnMallshopm < ActiveRecord::Migration
  def self.up
     change_column :mallshopms, :malladmin_id, :integer, :default=>0, :null =>false
    add_index :mallshopms, [:malladmin_id, :updated_at]
  end

  def self.down
    drop_index :mallshopms, [:malladmin_id, :updated_at]
  end
end
