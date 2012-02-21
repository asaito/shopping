class CreateCmdtystndrdmStndrdcontentmViews < ActiveRecord::Migration
  def self.up
    execute <<-ENDE
    CREATE VIEW cmdtystndrdm_stndrdcontentm_views AS
    SELECT a.shopcode, a.cmdtycode, a.stndrdcode1, a.elementcode1, a.stndrdcode2, a.elementcode2, a.amount, b.id, b.stndrdcode, b.elementcode, b.disporder, b.elementname FROM cmdtystndrdms a, stndrdcontentms b WHERE a.shopcode = b.shopcode AND (a.stndrdcode1 = b.stndrdcode OR a.stndrdcode2 = b.stndrdcode);

    ENDE

  end

  def self.down
    execute <<-ENDE
      DROP VIEW cmdtystndrdm_stndrdcontentm_views;
    ENDE
  end
end
