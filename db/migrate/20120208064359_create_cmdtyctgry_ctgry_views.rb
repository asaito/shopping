class CreateCmdtyctgryCtgryViews < ActiveRecord::Migration
  def self.up
    execute <<-ENDE
      CREATE VIEW cmdtyctgry_ctgry_views AS
      SELECT  a.ctgrycode, a.parentctgrycode, a.ctgryname, a.abbvctgryname, b.cmdtycode FROM ctgrymtbls a, cmdtyctgries b WHERE a.ctgrycode = b.ctgrycode;
    ENDE
  end

  def self.down
    execute <<-ENDE
      DROP VIEW cmdtyctgry_ctgry_views;
    ENDE
  end
end
