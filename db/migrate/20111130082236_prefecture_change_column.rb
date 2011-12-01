class PrefectureChangeColumn < ActiveRecord::Migration
  def self.up
    remove_column :prefectures, :id
    add_column :prefectures, :prefectureid, :integer
  end

  def self.down
  end
end
