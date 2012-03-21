class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :custcompanyflg
      t.string :custname
      t.string :custpronname
      t.string :email
      t.string :orderaddressee
      t.string :postcode1
      t.string :postcode2
      t.string :address2
      t.string :address3
      t.string :companyname
      t.string :tel
      t.string :fax
      t.string :paymethodname
      t.timestamp :initdatetime
      t.timestamp :updatedatetime
      t.integer :paymentflg
      t.integer :fee
      t.date :receiptdate
      t.integer :sendmailflg
      t.string :address1
      t.integer :sumofdiscount
      t.integer :sumbypoint
      t.text :contactmsg
      t.text :memo
      t.integer :taxrate
      t.integer :status
      t.integer :feetaxflg
      t.integer :custid
      t.integer :receiptmailflg
      t.integer :pointenableflg

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
