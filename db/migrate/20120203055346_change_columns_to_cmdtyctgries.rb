class ChangeColumnsToCmdtyctgries < ActiveRecord::Migration
  def self.up
     change_column :cmdtyctgries, :shopcode, :string, :null =>false
     change_column :cmdtyctgries, :cmdtycode, :string, :null =>false
     change_column :cmdtyctgries, :ctgrycode, :string, :null =>false
  end

  def self.down
  end
end
