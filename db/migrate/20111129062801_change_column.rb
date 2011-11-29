class ChangeColumn < ActiveRecord::Migration
  def self.up
    change_column :mallshopms, :postcode1, :string , :null => false
    change_column :mallshopms, :postcode2, :string , :null => false
    change_column :mallshopms, :address1, :string , :null => false
    change_column :mallshopms, :address2, :string , :null => false
    change_column :mallshopms, :tel, :string , :null => false
    change_column :mallshopms, :email, :string , :null => false
    change_column :mallshopms, :chargeusername , :string , :null => false
    change_column :mallshopms, :discountrate, :integer , :null => false, :default => 0
    change_column :mallshopms, :instockflg, :integer , :null => false, :default => 0
    change_column :mallshopms, :amountbyadvise, :integer , :null => false, :default => 0
    change_column :mallshopms, :giftflg, :integer , :null => false, :default => 0
    change_column :mallshopms, :status, :integer , :null => false, :default => 1
    change_column :mallshopms, :feetaxflg, :integer , :null => false, :default => 1
    change_column :mallshopms, :deliverytaxflg, :integer , :null => false, :default => 1
    change_column :mallshopms, :rankingdispflg, :integer , :null => false, :default => 1
    change_column :mallshopms, :rankingflg, :integer , :null => false, :default => 0
    change_column :mallshopms, :rankingcount, :integer , :null => false, :default => 0
    change_column :mallshopms, :rankingdays, :integer , :null => false, :default => 0

  end

  def self.down
  end
end
