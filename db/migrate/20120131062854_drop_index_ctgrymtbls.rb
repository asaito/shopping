class DropIndexCtgrymtbls < ActiveRecord::Migration
  def self.up
    remove_index :ctgrymtbls, [:ctgrycode, :ctgryname]
    add_index :ctgrymtbls, :ctgrycode, :unique=>true
    add_index :ctgrymtbls, :ctgryname, :unique=>true
  end

  def self.down
  end
end
