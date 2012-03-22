# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120322062356) do

  create_table "cmdtyctgries", :force => true do |t|
    t.string   "shopcode",   :null => false
    t.string   "cmdtycode",  :null => false
    t.string   "ctgrycode",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cmdtyname",  :null => false
  end

  create_table "cmdtystndrdms", :force => true do |t|
    t.string   "shopcode",                    :null => false
    t.string   "cmdtycode",                   :null => false
    t.string   "stndrdcode1"
    t.string   "elementcode1"
    t.string   "stndrdcode2"
    t.string   "elementcode2"
    t.integer  "amount",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comdties", :force => true do |t|
    t.string   "shopcode"
    t.string   "cmdtycode"
    t.string   "jancode"
    t.string   "cmdtyname"
    t.string   "description"
    t.string   "stockcode"
    t.integer  "stockunitprice"
    t.integer  "unitprice"
    t.integer  "salesunitprice"
    t.integer  "taxflg"
    t.integer  "adviceflg"
    t.string   "bannerfile"
    t.string   "bannerurl"
    t.integer  "memberdiscountflg"
    t.string   "srchkeyname1"
    t.string   "srchkeyname2"
    t.string   "srchkeyname3"
    t.string   "cmdtysize"
    t.date     "sellfromdate"
    t.integer  "endsellflg"
    t.date     "selltodate"
    t.date     "salesfromdate"
    t.date     "salestodate"
    t.integer  "rsrvenableflg"
    t.integer  "nostockflg"
    t.integer  "amount"
    t.integer  "stockstatuscode"
    t.integer  "wrappingflg"
    t.integer  "deliverytypecode"
    t.integer  "amountflg"
    t.integer  "rsrvamount"
    t.integer  "ranking"
    t.datetime "rankingdatetime"
    t.datetime "initdatetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conncmdtyms", :force => true do |t|
    t.string   "shopcode",                     :null => false
    t.string   "cmdtycode",                    :null => false
    t.string   "connshopcode",                 :null => false
    t.string   "conncmdtycode",                :null => false
    t.integer  "disporder",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ctgrylists", :force => true do |t|
    t.string   "ctgryname"
    t.string   "path"
    t.string   "parent"
    t.string   "ctgrycode"
    t.string   "parentctgrycode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ctgrymtbls", :force => true do |t|
    t.string   "ctgrycode",       :null => false
    t.string   "parentctgrycode", :null => false
    t.string   "ctgryname",       :null => false
    t.string   "abbvctgryname",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ctgrymtbls", ["ctgrycode"], :name => "index_ctgrymtbls_on_ctgrycode", :unique => true
  add_index "ctgrymtbls", ["ctgryname"], :name => "index_ctgrymtbls_on_ctgryname", :unique => true
  add_index "ctgrymtbls", ["id", "updated_at"], :name => "index_ctgrymtbls_on_id_and_updated_at"

  create_table "custaddresses", :force => true do |t|
    t.integer  "custcompanyflg",    :default => 0, :null => false
    t.string   "deliveryname",                     :null => false
    t.string   "deliveryaddressee",                :null => false
    t.string   "email"
    t.string   "postcode1",                        :null => false
    t.string   "postcode2",                        :null => false
    t.string   "address1",                         :null => false
    t.string   "address2",                         :null => false
    t.string   "address3"
    t.string   "companyname"
    t.string   "fax"
    t.integer  "sendmailflg",       :default => 0, :null => false
    t.integer  "daysbeforehand",    :default => 0, :null => false
    t.integer  "mailmonth"
    t.integer  "mailday"
    t.date     "lastdeliverydate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custid",                           :null => false
  end

  create_table "custattrms", :force => true do |t|
    t.integer  "attrflag",                  :null => false
    t.string   "attrname",                  :null => false
    t.integer  "disporder",  :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custs", :force => true do |t|
    t.integer  "memberlevelcode",                :null => false
    t.integer  "custcompanyflg",  :default => 0, :null => false
    t.string   "custname",                       :null => false
    t.string   "custpronname",                   :null => false
    t.string   "email",                          :null => false
    t.string   "password",                       :null => false
    t.string   "pwquestion"
    t.string   "pwanswer"
    t.string   "postcode1",                      :null => false
    t.string   "postcode2",                      :null => false
    t.string   "address1",                       :null => false
    t.string   "address2",                       :null => false
    t.string   "address3"
    t.string   "companyname"
    t.string   "tel"
    t.string   "fax"
    t.integer  "paymethodcode"
    t.date     "birthdate"
    t.integer  "sex",             :default => 0, :null => false
    t.integer  "newmailflg",      :default => 0, :null => false
    t.string   "job"
    t.string   "howtoknow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hobby"
  end

  create_table "emp", :id => false, :force => true do |t|
    t.string  "empno", :null => false
    t.string  "ename"
    t.string  "job"
    t.string  "mgr"
    t.integer "sal"
    t.integer "comm"
  end

  create_table "fs", :force => true do |t|
    t.string  "name",      :limit => nil
    t.integer "parent_id"
  end

  create_table "malladmins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "malladmins", ["email"], :name => "index_malladmins_on_email", :unique => true
  add_index "malladmins", ["reset_password_token"], :name => "index_malladmins_on_reset_password_token", :unique => true

  create_table "mallshopms", :force => true do |t|
    t.string   "mallshopcode",                     :null => false
    t.integer  "mallshopflg",       :default => 1, :null => false
    t.string   "mallshopname",                     :null => false
    t.string   "mallshopnamekana"
    t.integer  "malladmin_id",      :default => 0, :null => false
    t.string   "malladminpass",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "frontshopname"
    t.string   "frontshopnamekana"
    t.string   "departname"
    t.string   "postcode1",                        :null => false
    t.string   "postcode2",                        :null => false
    t.string   "address1",                         :null => false
    t.string   "address2",                         :null => false
    t.string   "address3"
    t.string   "tel",                              :null => false
    t.string   "fax"
    t.string   "email",                            :null => false
    t.string   "chargeusername",                   :null => false
    t.date     "discountfromdate"
    t.date     "discounttodate"
    t.integer  "discountrate",      :default => 0, :null => false
    t.integer  "instockflg",        :default => 0, :null => false
    t.integer  "amountbyadvise",    :default => 0, :null => false
    t.string   "abbvfrontshopname"
    t.integer  "daysofnew",         :default => 0
    t.integer  "giftflg",           :default => 0, :null => false
    t.integer  "status",            :default => 1, :null => false
    t.integer  "feetaxflg",         :default => 1, :null => false
    t.integer  "deliverytaxflg",    :default => 1, :null => false
    t.integer  "rankingdispflg",    :default => 1, :null => false
    t.integer  "rankingflg",        :default => 0, :null => false
    t.integer  "rankingcount",      :default => 0, :null => false
    t.integer  "rankingdays",       :default => 0, :null => false
    t.datetime "rankingdatetime"
    t.integer  "pointenableflg",    :default => 0
  end

  add_index "mallshopms", ["malladmin_id", "updated_at"], :name => "index_mallshopms_on_malladmin_id_and_updated_at"

  create_table "memberlevelms", :force => true do |t|
    t.integer  "memberlevel",                    :null => false
    t.string   "memberlevelname",                :null => false
    t.integer  "discountrate",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "custcompanyflg", :default => 0, :null => false
    t.string   "custname",                      :null => false
    t.string   "custpronname",                  :null => false
    t.string   "email"
    t.string   "orderaddressee",                :null => false
    t.string   "postcode1",                     :null => false
    t.string   "postcode2",                     :null => false
    t.string   "address2",                      :null => false
    t.string   "address3"
    t.string   "companyname"
    t.string   "tel"
    t.string   "fax"
    t.string   "paymethodname"
    t.datetime "initdatetime",                  :null => false
    t.datetime "updatedatetime",                :null => false
    t.integer  "paymentflg",     :default => 0, :null => false
    t.integer  "fee",            :default => 0, :null => false
    t.date     "receiptdate"
    t.integer  "sendmailflg",    :default => 0, :null => false
    t.string   "address1",                      :null => false
    t.integer  "sumofdiscount",  :default => 0, :null => false
    t.integer  "sumbypoint",     :default => 0, :null => false
    t.text     "contactmsg"
    t.text     "memo"
    t.integer  "taxrate",        :default => 0, :null => false
    t.integer  "status",         :default => 0, :null => false
    t.integer  "feetaxflg",      :default => 1, :null => false
    t.integer  "custid",                        :null => false
    t.integer  "receiptmailflg", :default => 0, :null => false
    t.integer  "pointenableflg", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paymethodms", :force => true do |t|
    t.string   "mallshopcode",                    :null => false
    t.integer  "paymethodcode",                   :null => false
    t.string   "paymethodname", :default => "通常", :null => false
    t.integer  "paymentflg",    :default => 0,    :null => false
    t.integer  "fee",           :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pointmanms", :force => true do |t|
    t.string   "mallshopcode",                 :null => false
    t.integer  "issueflg",      :default => 0
    t.integer  "orderid"
    t.integer  "reviewid"
    t.datetime "issuedatetime",                :null => false
    t.integer  "enableflg",     :default => 1
    t.integer  "pointofissue",  :default => 0, :null => false
    t.integer  "custid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prefectures", :id => false, :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id",         :null => false
  end

  create_table "srchctgrymtbls", :force => true do |t|
    t.string   "ctgrycode",                  :null => false
    t.integer  "srchkeycode",                :null => false
    t.string   "srchkeyname",                :null => false
    t.integer  "disptype",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stndrdcontentms", :force => true do |t|
    t.string   "shopcode",    :null => false
    t.string   "stndrdcode",  :null => false
    t.string   "elementcode", :null => false
    t.integer  "disporder",   :null => false
    t.string   "elementname", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stndrdcontentms", ["shopcode"], :name => "index_stndrdcontentms_on_shopcode"

  create_table "stndrdnamems", :force => true do |t|
    t.string   "shopcode",   :null => false
    t.string   "stndrdcode", :null => false
    t.string   "stndrdname", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stockms", :force => true do |t|
    t.string   "shopcode",       :null => false
    t.string   "stockcode",      :null => false
    t.string   "stockname",      :null => false
    t.string   "tel"
    t.string   "fax"
    t.string   "email"
    t.string   "chargeusername"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stockstatusms", :force => true do |t|
    t.integer  "stockstatuscode",                   :null => false
    t.string   "stockstatusname"
    t.string   "commentofnostock"
    t.integer  "amountoflessstock",  :default => 0, :null => false
    t.string   "commentoflessstock"
    t.string   "commentofmorestock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wrappingms", :force => true do |t|
    t.string   "shopcode",                    :null => false
    t.string   "wrappingcode",                :null => false
    t.string   "wrappingname",                :null => false
    t.string   "description"
    t.integer  "price",        :default => 0, :null => false
    t.integer  "taxflg",       :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
