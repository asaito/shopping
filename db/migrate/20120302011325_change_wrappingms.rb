class ChangeWrappingms < ActiveRecord::Migration
  def self.up
    change_column :wrappingms, :shopcode, :string, :null => false
    change_column :wrappingms, :wrappingcode, :string, :null => false
    change_column :wrappingms, :wrappingname, :string, :null => false
    change_column :wrappingms, :price, :integer, :default => 0, :null => false
    change_column :wrappingms, :taxflg, :integer, :default => 1, :null => false
  end

  def self.down
  end
end
