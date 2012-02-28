class ChangeConncmdtyms < ActiveRecord::Migration
  def self.up
    change_column :conncmdtyms, :shopcode, :string, :null =>false
    change_column :conncmdtyms, :cmdtycode, :string, :null =>false
    change_column :conncmdtyms, :connshopcode, :string, :null =>false
    change_column :conncmdtyms, :conncmdtycode, :string, :null =>false
    change_column :conncmdtyms, :disporder, :integer, :null =>false, :default => 0
  end

  def self.down
  end
end
