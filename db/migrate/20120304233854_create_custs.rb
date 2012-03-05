class CreateCusts < ActiveRecord::Migration
  def self.up
    create_table :custs do |t|
      t.integer :memberlevelcode
      t.integer :custcompanyflg
      t.string :custname
      t.string :custpronname
      t.string :email
      t.string :password
      t.string :pwquestion
      t.string :pwanswer
      t.string :postcode1
      t.string :postcode2
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :companyname
      t.string :tel
      t.string :fax
      t.integer :paymethodcode
      t.date :birthdate
      t.integer :sex
      t.integer :newmailflg
      t.string :job
      t.string :howtoknow
      t.integer :custcode

      t.timestamps
    end
  end

  def self.down
    drop_table :custs
  end
end
