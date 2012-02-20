class CreateCmdtystndrdms < ActiveRecord::Migration
  def self.up
    create_table :cmdtystndrdms do |t|
      t.string :shopcode
      t.string :cmdtycode
      t.string :stndrdcode1
      t.string :elementcode1
      t.string :stndrdcode2
      t.string :elementcode2
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :cmdtystndrdms
  end
end
