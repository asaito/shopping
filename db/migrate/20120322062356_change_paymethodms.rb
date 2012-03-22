# -*- encoding: utf-8 -*-
class ChangePaymethodms < ActiveRecord::Migration
  def self.up
change_column :paymethodms, :mallshopcode, :string, :null => false
change_column :paymethodms, :paymethodcode, :integer, :null => false
change_column :paymethodms, :paymethodname, :string, :default => '通常', :null => false
change_column :paymethodms, :paymentflg, :integer, :default => 0, :null => false
change_column :paymethodms, :fee, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
