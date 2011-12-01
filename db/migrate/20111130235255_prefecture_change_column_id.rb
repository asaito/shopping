class PrefectureChangeColumnId < ActiveRecord::Migration
  def self.up
    remove_column :prefectures, :prefectureid
    add_column :prefectures, :id, :integer
  end

  def self.down
  end
end
