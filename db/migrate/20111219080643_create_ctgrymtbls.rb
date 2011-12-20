class CreateCtgrymtbls < ActiveRecord::Migration
  def self.up
    create_table :ctgrymtbls do |t|
      t.string :ctgrycode
      t.string :parentctgrycode
      t.string :ctgryname
      t.string :abbvctgryname

      t.timestamps
    end
  end

  def self.down
    drop_table :ctgrymtbls
  end
end
