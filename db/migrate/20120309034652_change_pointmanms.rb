class ChangePointmanms < ActiveRecord::Migration
  def self.up
    change_column :pointmanms, :mallshopcode, :string, :null => false
    change_column :pointmanms, :issueflg, :integer, :default => 0
    change_column :pointmanms, :issuedatetime, :timestamp, :null => false
    change_column :pointmanms, :enableflg, :integer, :default => 1
    change_column :pointmanms, :pointofissue, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
