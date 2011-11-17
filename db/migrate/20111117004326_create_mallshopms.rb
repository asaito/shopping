class CreateMallshopms < ActiveRecord::Migration
  def self.up
    create_table :mallshopms do |t|
      t.string :mallshopcode
      t.integer :mallshopflg
      t.string :mallshopname
      t.string :mallshopnamekana
      t.integer :malladmin_id
      t.string :malladminname
      t.string :malladminpass

      t.timestamps
    end
  end

  def self.down
    drop_table :mallshopms
  end
end
