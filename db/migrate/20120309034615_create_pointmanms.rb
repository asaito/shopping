class CreatePointmanms < ActiveRecord::Migration
  def self.up
    create_table :pointmanms do |t|
      t.string :mallshopcode
      t.integer :issueflg
      t.integer :orderid
      t.integer :reviewid
      t.date :issuedatetime
      t.integer :enableflg
      t.integer :pointofissue
      t.integer :custid

      t.timestamps
    end
  end

  def self.down
    drop_table :pointmanms
  end
end
