class CreateStockstatusms < ActiveRecord::Migration
  def self.up
    create_table :stockstatusms do |t|
      t.integer :stockstatuscode
      t.string :stockstatusname
      t.string :commentofnostock
      t.integer :amountoflessstock
      t.string :commentoflessstock
      t.string :commentofmorestock

      t.timestamps
    end
  end

  def self.down
    drop_table :stockstatusms
  end
end
