class ChangeColumnNotNull < ActiveRecord::Migration
  def self.up
    change_column :ctgrymtbls, :ctgrycode, :string, :null =>false
    change_column :ctgrymtbls, :parentctgrycode, :string, :null =>false
    change_column :ctgrymtbls, :ctgryname, :string, :null =>false
    change_column :ctgrymtbls, :abbvctgryname, :string, :null =>false
  end

  def self.down
  end
end
