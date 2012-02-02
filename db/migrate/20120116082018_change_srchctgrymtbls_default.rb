class ChangeSrchctgrymtblsDefault < ActiveRecord::Migration
  def self.up
    change_column :srchctgrymtbls, :disptype, :integer, :null =>false, :default => 0
  end

  def self.down
  end
end
