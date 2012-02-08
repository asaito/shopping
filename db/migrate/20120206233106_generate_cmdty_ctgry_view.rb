class GenerateCmdtyCtgryView < ActiveRecord::Migration
  def self.up
    #execute <<-ENDE
     # CREATE VIEW cmdty_ctgry_view AS
     # SELECT  a.shopcode, a.cmdtycode, a.jancode, a.cmdtyname, a.description, a.stockcode, a.stockunitprice, a.unitprice, a.salesunitprice, a.taxflg, a.adviceflg, a.bannerfile, a.bannerurl, a.memberdiscountflg, a.srchkeyname1, a.srchkeyname2, a.srchkeyname3, a.cmdtysize, a.sellfromdate, a.endsellflg, a.selltodate, a.salesfromdate, a.salestodate, a.rsrvenableflg, a.nostockflg, a.amount, a.stockstatuscode, a.wrappingflg, a.deliverytypecode, a.amountflg, a.rsrvamount, a.ranking, a.rankingdatetime, a.initdatetime, a.created_at, a.updated_at, b.ctgrycode FROM comdties a, cmdtyctgries b WHERE a.cmdtycode = b.cmdtycode;
   # ENDE
  end

  def self.down
    #execute <<-ENDE
     # DROP VIEW cmdty_ctgry_view;
    #ENDE
  end
end
