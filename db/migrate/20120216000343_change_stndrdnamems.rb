class ChangeStndrdnamems < ActiveRecord::Migration
  def self.up
     change_column :stndrdnamems, :shopcode, :string, :null =>false
     change_column :stndrdnamems, :stndrdcode, :string, :null =>false
     change_column :stndrdnamems, :stndrdname, :string, :null =>false
  end

  def self.down
  end
end
