class ChangeCmdtystndrds < ActiveRecord::Migration
  def self.up
    change_column :cmdtystndrdms, :shopcode, :string, :null => false
    change_column :cmdtystndrdms, :cmdtycode, :string, :null => false
    change_column :cmdtystndrdms, :amount, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
