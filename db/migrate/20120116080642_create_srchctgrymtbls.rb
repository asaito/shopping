class CreateSrchctgrymtbls < ActiveRecord::Migration
  def self.up
    create_table :srchctgrymtbls do |t|
      t.string :ctgrycode
      t.integer :srchkeycode
      t.string :srchkeyname
      t.integer :disptype

      t.timestamps
    end
  end

  def self.down
    drop_table :srchctgrymtbls
  end
end
