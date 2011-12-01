class ChangeAttributeOfIdOfPrefecture < ActiveRecord::Migration
  def self.up
    change_column :prefectures, :id, :string, :null => false
  end

  def self.down
  end
end
