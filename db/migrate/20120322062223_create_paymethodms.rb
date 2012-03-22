class CreatePaymethodms < ActiveRecord::Migration
  def self.up
    create_table :paymethodms do |t|
      t.string :mallshopcode
      t.integer :paymethodcode
      t.string :paymethodname
      t.integer :paymentflg
      t.integer :fee

      t.timestamps
    end
  end

  def self.down
    drop_table :paymethodms
  end
end
