class CreateCmdtyctgries < ActiveRecord::Migration
  def self.up
    create_table :cmdtyctgries do |t|
      t.string :shopcode
      t.string :cmdtycode
      t.string :ctgrycode

      t.timestamps
    end
  end

  def self.down
    drop_table :cmdtyctgries
  end
end
