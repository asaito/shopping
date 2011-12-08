class CreateComdtyms < ActiveRecord::Migration
  def self.up
    create_table :comdtyms do |t|
      t.string :SHOPCODE
      t.string :CmdtyCode
      t.string :JanCode
      t.string :CmdtyName
      t.string :Description
      t.string :StockCode
      t.integer :StockUnitPrice
      t.integer :UnitPrice
      t.integer :SalesUnitPrice
      t.integer :TaxFlg
      t.integer :AdviceFlg
      t.string :BannerFile
      t.string :BannerURL
      t.integer :MemberDiscountFlg
      t.string :SrchKeyName1
      t.string :SrchKeyName2
      t.string :SrchKeyName3
      t.string :CmdtySize
      t.date :SellFromDate
      t.integer :EndSellFlg
      t.date :SellToDate
      t.date :SalesFromDate
      t.date :SalesToDate
      t.integer :RsrvEnableFlg
      t.integer :RsrvAmount
      t.integer :NoStockFlg
      t.integer :Amount
      t.integer :AmountFlg
      t.integer :StockStatusCode
      t.integer :WrappingFlg
      t.integer :DeliveryTypeCode
      t.integer :Ranking
      t.timestamp :RankingDateTime
      t.timestamp :InitDateTime

      t.timestamps
    end
  end

  def self.down
    drop_table :comdtyms
  end
end
