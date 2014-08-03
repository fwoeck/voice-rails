# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140803051930) do

  create_table "languages", force: true do |t|
    t.integer "user_id"
    t.string  "name",    default: "", null: false
  end

  add_index "languages", ["user_id"], name: "index_languages_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.integer "user_id"
    t.string  "name",    default: "", null: false
  end

  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "skills", force: true do |t|
    t.integer "user_id"
    t.string  "name",    default: "", null: false
  end

  add_index "skills", ["user_id"], name: "index_skills_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 80,  default: "",                    null: false
    t.string   "accountcode",            limit: 20
    t.string   "amaflags",               limit: 7
    t.string   "callgroup",              limit: 10
    t.string   "callerid",               limit: 80
    t.string   "dial",                   limit: 80
    t.string   "callbackextension",      limit: 40
    t.string   "canreinvite",            limit: 3,   default: "no"
    t.string   "context",                limit: 80,  default: "adhearsion"
    t.string   "defaultip",              limit: 15
    t.string   "dtmfmode",               limit: 7,   default: "rfc2833"
    t.string   "fromuser",               limit: 80
    t.string   "fromdomain",             limit: 80
    t.string   "fullcontact",            limit: 80
    t.string   "host",                   limit: 31,  default: "dynamic",             null: false
    t.string   "insecure",               limit: 20
    t.string   "language",               limit: 2
    t.string   "mailbox",                limit: 50
    t.string   "md5secret",              limit: 80
    t.string   "nat",                    limit: 30,  default: "force_rport,comedia", null: false
    t.string   "deny",                   limit: 95
    t.string   "permit",                 limit: 95
    t.string   "mask",                   limit: 95
    t.string   "pickupgroup",            limit: 10
    t.string   "port",                   limit: 5,   default: "5060",                null: false
    t.string   "qualify",                limit: 3,   default: "no"
    t.string   "restrictcid",            limit: 1
    t.string   "rtptimeout",             limit: 3
    t.string   "rtpholdtimeout",         limit: 3
    t.string   "secret",                 limit: 80
    t.string   "type",                   limit: 6,   default: "friend",              null: false
    t.string   "disallow",               limit: 100, default: "all"
    t.string   "allow",                  limit: 100, default: "opus,alaw,ulaw"
    t.string   "musiconhold",            limit: 100
    t.integer  "regseconds",                         default: 0,                     null: false
    t.string   "ipaddr",                 limit: 50,  default: "",                    null: false
    t.string   "regexten",               limit: 80,  default: "",                    null: false
    t.string   "cancallforward",         limit: 3,   default: "no"
    t.string   "transport",              limit: 10,  default: "udp"
    t.string   "encryption",             limit: 3,   default: "no"
    t.string   "directmedia",            limit: 3,   default: "no"
    t.string   "defaultuser",            limit: 10
    t.string   "regserver",              limit: 20
    t.string   "useragent",              limit: 20
    t.string   "lastms",                 limit: 11
    t.string   "email",                              default: "",                    null: false
    t.string   "encrypted_password",                 default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname",                           default: ""
    t.string   "zendesk_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["id"], name: "id", unique: true, using: :btree
  add_index "users", ["name"], name: "name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
