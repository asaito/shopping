class CreateComdties < ActiveRecord::Migration
  def self.up
    create_table :comdties do |t|
      t.string :shopcode
      t.string :cmdtycode
      t.string :jancode
      t.string :cmdtyname
      t.string :description
      t.string :stockcode
      t.integer :stockunitprice
      t.integer :unitprice
      t.integer :salesunitprice
      t.integer :taxflg
      t.integer :adviceflg
      t.string :bannerfile
      t.string :bannerurl
      t.integer :memberdiscountflg
      t.string :srchkeyname1
      t.string :srchkeyname2
      t.string :srchkeyname3
      t.string :cmdtysize
      t.date :sellfromdate
      t.integer :endsellflg
      t.date :selltodate
      t.date :salesfromdate
      t.date :salestodate
      t.integer :rsrvenableflg
      t.integer :nostockflg
      t.integer :amount
      t.integer :stockstatuscode
      t.integer :wrappingflg
      t.integer :deliverytypecode
      t.integer :amountflg
      t.integer :rsrvamount
      t.integer :ranking
      t.timestamp :rankingdatetime
      t.timestamp :initdatetime

      t.timestamps
    end
  end

  def self.down
    drop_table :comdties
  end
end
