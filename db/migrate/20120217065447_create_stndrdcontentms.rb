class CreateStndrdcontentms < ActiveRecord::Migration
  def self.up
    create_table :stndrdcontentms do |t|
      t.string :shopcode
      t.string :stndrdcode
      t.string :elementcode
      t.integer :disporder
      t.string :elementname

      t.timestamps
    end
  end

  def self.down
    drop_table :stndrdcontentms
  end
end
