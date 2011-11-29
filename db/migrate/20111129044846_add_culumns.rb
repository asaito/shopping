class AddCulumns < ActiveRecord::Migration
  def self.up
    change_column :mallshopms, :mallshopcode, :string, :null => false
    change_column :mallshopms, :mallshopflg, :integer, :null => false, :default => 1
    change_column :mallshopms, :mallshopname, :string, :null => false
    change_column :mallshopms, :malladminpass, :string,:null => false
    add_column :mallshopms, :frontshopname, :string
    add_column :mallshopms, :frontshopnamekana, :string
    add_column :mallshopms, :departname, :string
    add_column :mallshopms, :postcode1, :string #, :null => false
    add_column :mallshopms, :postcode2, :string #, :null => false
    add_column :mallshopms, :address1, :string #, :null => false
    add_column :mallshopms, :address2, :string #, :null => false
    add_column :mallshopms, :address3, :string
    add_column :mallshopms, :tel, :string #, :null => false
    add_column :mallshopms, :fax, :string
    add_column :mallshopms, :email, :string #, :null => false
    add_column :mallshopms, :chargeusername , :string #, :null => false
    add_column :mallshopms, :discountfromdate, :date
    add_column :mallshopms, :discounttodate, :date
    add_column :mallshopms, :discountrate, :integer #, :null => false, :default => 0
    add_column :mallshopms, :instockflg, :integer #, :null => false, :default => 0
    add_column :mallshopms, :amountbyadvise, :integer #, :null => false, :default => 0
    add_column :mallshopms, :initdatetime, :timestamp
    add_column :mallshopms, :abbvfrontshopname, :string
    add_column :mallshopms, :daysofnew, :integer, :default => 0
    add_column :mallshopms, :giftflg, :integer #, :null => false, :default => 0
    add_column :mallshopms, :status, :integer #, :null => false, :default => 1
    add_column :mallshopms, :feetaxflg, :integer #, :null => false, :default => 1
    add_column :mallshopms, :deliverytaxflg, :integer #, :null => false, :default => 1
    add_column :mallshopms, :rankingdispflg, :integer #, :null => false, :default => 1
    add_column :mallshopms, :rankingflg, :integer #, :null => false, :default => 0
    add_column :mallshopms, :rankingcount, :integer #, :null => false, :default => 0
    add_column :mallshopms, :rankingdays, :integer #, :null => false, :default => 0
    add_column :mallshopms, :rankingdatetime, :timestamp

  end

  def self.down
  end
end
