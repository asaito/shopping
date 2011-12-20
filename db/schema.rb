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

ActiveRecord::Schema.define(:version => 20111220000142) do

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

  create_table "ctgrymtbls", :force => true do |t|
    t.string   "ctgrycode",       :null => false
    t.string   "parentctgrycode", :null => false
    t.string   "ctgryname",       :null => false
    t.string   "abbvctgryname",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ctgrymtbls", ["id", "updated_at"], :name => "index_ctgrymtbls_on_id_and_updated_at"

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

  create_table "prefectures", :id => false, :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id",         :null => false
  end

end
