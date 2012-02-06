class AddColumnToCmdtyctgry < ActiveRecord::Migration
  def self.up
    add_column :cmdtyctgries, :cmdtyname, :string, :null => false
  end

  def self.down
  end
end
