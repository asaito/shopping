class CreateCtgrylists < ActiveRecord::Migration
  def self.up
    create_table :ctgrylists do |t|
      t.string :ctgryname
      t.string :path
      t.string :parent
      t.string :ctgrycode
      t.string :parentctgrycode

      t.timestamps
    end
  end

  def self.down
    drop_table :ctgrylists
  end
end
