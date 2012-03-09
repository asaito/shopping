class AddColumnCusts < ActiveRecord::Migration
  def self.up
    add_column :custs, :hobby, :string
  end

  def self.down
  end
end
