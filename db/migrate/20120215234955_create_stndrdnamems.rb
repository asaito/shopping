class CreateStndrdnamems < ActiveRecord::Migration
  def self.up
    create_table :stndrdnamems do |t|
      t.string :shopcode
      t.string :stndrdcode
      t.string :stndrdname

      t.timestamps
    end
  end

  def self.down
    drop_table :stndrdnamems
  end
end
