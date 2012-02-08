class CreateCmdtyCtgryViews < ActiveRecord::Migration
  def self.up
    #create_table :cmdty_ctgry_views do |t|
     # t.timestamps
    #end
    CmdtyCtgryView.connection.execute <<-ENDE
      CREATE VIEW cmdty_ctgry_views AS
      SELECT  a.shopcode, a.cmdtycode, a.jancode, a.cmdtyname, a.description, a.stockcode, a.stockunitprice, a.unitprice, a.salesunitprice, a.taxflg, a.adviceflg, a.bannerfile, a.bannerurl, a.memberdiscountflg, a.srchkeyname1, a.srchkeyname2, a.srchkeyname3, a.cmdtysize, a.sellfromdate, a.endsellflg, a.selltodate, a.salesfromdate, a.salestodate, a.rsrvenableflg, a.nostockflg, a.amount, a.stockstatuscode, a.wrappingflg, a.deliverytypecode, a.amountflg, a.rsrvamount, a.ranking, a.rankingdatetime, a.initdatetime, a.created_at, a.updated_at, b.ctgrycode FROM comdties a, cmdtyctgries b WHERE a.cmdtycode = b.cmdtycode;
    ENDE

  end

  def self.down
    #drop_table :cmdty_ctgry_views
    execute <<-ENDE
      DROP VIEW cmdty_ctgry_views;
    ENDE
  end
end
