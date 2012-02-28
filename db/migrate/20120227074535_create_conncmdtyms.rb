class CreateConncmdtyms < ActiveRecord::Migration
  def self.up
    create_table :conncmdtyms do |t|
      t.string :shopcode
      t.string :cmdtycode
      t.string :connshopcode
      t.string :conncmdtycode
      t.integer :disporder

      t.timestamps
    end
  end

  def self.down
    drop_table :conncmdtyms
  end
end
