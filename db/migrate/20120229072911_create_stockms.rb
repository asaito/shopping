class CreateStockms < ActiveRecord::Migration
  def self.up
    create_table :stockms do |t|
      t.string :shopcode
      t.string :stockcode
      t.string :stockname
      t.string :tel
      t.string :fax
      t.string :email
      t.string :chargeusername

      t.timestamps
    end
  end

  def self.down
    drop_table :stockms
  end
end
