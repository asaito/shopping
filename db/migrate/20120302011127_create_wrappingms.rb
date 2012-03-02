class CreateWrappingms < ActiveRecord::Migration
  def self.up
    create_table :wrappingms do |t|
      t.string :shopcode
      t.string :wrappingcode
      t.string :wrappingname
      t.string :description
      t.integer :price
      t.integer :taxflg

      t.timestamps
    end
  end

  def self.down
    drop_table :wrappingms
  end
end
