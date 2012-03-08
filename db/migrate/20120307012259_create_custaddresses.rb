class CreateCustaddresses < ActiveRecord::Migration
  def self.up
    create_table :custaddresses do |t|
      t.integer :addresscode
      t.integer :custcompanyflg
      t.string :deliveryname
      t.string :deliveryaddressee
      t.string :email
      t.string :postcode1
      t.string :postcode2
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :companyname
      t.string :fax
      t.integer :sendmailflg
      t.integer :daysbeforehand
      t.integer :mailmonth
      t.integer :mailday
      t.date :lastdeliverydate
      t.integer :custid

      t.timestamps
    end
  end

  def self.down
    drop_table :custaddresses
  end
end
