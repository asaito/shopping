class ChangeSrchctgrymtbls < ActiveRecord::Migration
  def self.up
    change_column :srchctgrymtbls, :ctgrycode, :string, :null =>false
    change_column :srchctgrymtbls, :srchkeycode, :integer, :null =>false
    change_column :srchctgrymtbls, :srchkeyname, :string, :null =>false
    change_column :srchctgrymtbls, :disptype, :integer, :null =>false
  end

  def self.down
  end
end
