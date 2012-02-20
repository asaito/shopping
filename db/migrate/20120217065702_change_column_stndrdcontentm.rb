class ChangeColumnStndrdcontentm < ActiveRecord::Migration
  def self.up
    change_column :stndrdcontentms, :shopcode, :string, :null =>false
    change_column :stndrdcontentms, :stndrdcode, :string, :null =>false
    change_column :stndrdcontentms, :elementcode, :string, :null =>false
    change_column :stndrdcontentms, :disporder, :integer, :null =>false
    change_column :stndrdcontentms, :elementname, :string, :null =>false
    add_index :stndrdcontentms, [:shopcode]
  end

  def self.down
    drop_index :stndrdcontentms, [:shopcode]
  end
end
