# -*- encoding: utf-8 -*-
require 'csv'
class PointusesController < ApplicationController
  def index
    if params["serch_image.x"]
      serchwhere = getwhere
      logd("serchwhere:", serchwhere)
      $pointmanms = Pointmanm.find_by_sql("select * from pointmanms where " + serchwhere)
    elsif params["allcsv_image.x"]
      csv($pointmanms)
    elsif params["custcsv_image.x"]
      serchwhere = getwhere
      custs = Pointmanm.find_by_sql("select distinct custid from pointmanms where " + serchwhere)
      custs.each do |c|
	sql = "select * from pointmanms where " + serchwhere + " AND custid = '" + c.custid.to_s + "'"
	logd("sql:", sql)
	points = Pointmanm.find_by_sql(sql)
	csv(points)
      end
    elsif params["totalcsv_image.x"]
    end
    @id_serch = params[:id_serch]
    @issueflg = params[:issueflg]
    @enableflg = params[:enableflg]
    aa = @issueflg == "all" ? "checked":""
    logd("@issueflg:", @issueflg)
    logd("aa:", aa)
    if params[:issuefrom] != nil
      @issuefrom = Date.new(params[:issuefrom]["year"].to_i, params[:issuefrom]["month"].to_i, params[:issuefrom]["day"].to_i)
    else
      @issuefrom = Date.today
    end
    if params[:issueto] != nil
      @issueto = Date.new(params[:issueto]["year"].to_i, params[:issueto]["month"].to_i, params[:issueto]["day"].to_i)
    else
      @issueto = Date.today
    end
    logd("@issuefrom:", @issuefrom)
    logd("@issueto:", @issueto)
  end

  def getwhere
    where = ""
    nextop = ""
    if params[:id_serch] != nil && params[:id_serch] != ""
      where = "id = '" + params[:id_serch] + "'"
      nextop = " AND "
    else
      nextop = ""
    end
    if params[:issueflg] == "all"
    elsif params[:issueflg] == "buy"
      where += nextop + "issueflg = '0'"
      nextop = " AND "
    elsif params[:issueflg] == "review"
      where += nextop + "issueflg = '1'"
      nextop = " AND "
    elsif params[:issueflg] == "else"
      where += nextop + "issueflg = '2'"
      nextop = " AND "
    end
    if params[:enableflg] == "all"
    elsif params[:enableflg] == "no"
      where += nextop + "enableflg = '0'"
      nextop = " AND "
    elsif params[:enableflg] == "yes"
      where += nextop + "enableflg = '1'"
      nextop = " AND "
    elsif params[:enableflg] == "kari"
      where += nextop + "enableflg = '2'"
      nextop = " AND "
    end
    logd("params[:issuefrom]:", params[:issuefrom])
    yearfrom = params[:issuefrom]["year"]
    logd("yearfrom:", yearfrom)
    monthfrom = check2digit(params[:issuefrom]["month"])
    dayfrom = check2digit(params[:issuefrom]["day"])
    yearto = params[:issueto]["year"]
    monthto = check2digit(params[:issueto]["month"])
    dayto = check2digit(params[:issueto]["day"])
    where += nextop + "issuedatetime >= '" + yearfrom+monthfrom+dayfrom + "' AND " +  "issuedatetime <= '" + yearto+monthto+dayto + "'"
    return where
  end

  def check2digit(digit)
    s = digit.to_s
    if s.size == 1
      s = "0" + s
    end
    s
  end

  def csv(pointmanms)
    filename = "pointmanms#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    filepath = "tmp/csv/" + filename
    output = CSV.open(filepath, "a") do |csv|
      csv << ['ID', 'ショップコード', '発行種別', '受注コード', 'レビューコード', '発行日時', '有効フラグ', '発行ポイント', '顧客ID']
      pointmanms.each do |point|
        csv << [point.id, point.mallshopcode, point.issueflg, point.orderid, point.reviewid, point.issuedatetime, point.enableflg, point.pointofissue, point.custid]
      end
    end
  end

end
