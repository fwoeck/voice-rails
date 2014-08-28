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

ActiveRecord::Schema.define(version: 20140823061302) do

  create_table "languages", force: true do |t|
    t.integer "user_id"
    t.string  "name",    default: "", null: false
  end

  add_index "languages", ["user_id"], name: "index_languages_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "skills", force: true do |t|
    t.integer "user_id"
    t.string  "name",    default: "", null: false
  end

  add_index "skills", ["user_id"], name: "index_skills_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 80
    t.string   "secret",                 limit: 80
    t.string   "md5secret",              limit: 80
    t.string   "fullcontact",            limit: 80
    t.string   "host",                   limit: 31, default: "dynamic", null: false
    t.string   "ipaddr",                 limit: 50, default: "",        null: false
    t.string   "port",                   limit: 5,  default: "5060",    null: false
    t.string   "type",                   limit: 6,  default: "friend",  null: false
    t.string   "qualify",                limit: 3,  default: "no"
    t.string   "regserver"
    t.integer  "regseconds",                        default: 0,         null: false
    t.string   "defaultuser",            limit: 10
    t.string   "callbackextension",      limit: 40
    t.string   "useragent",              limit: 20
    t.string   "insecure",               limit: 20
    t.string   "lastms",                 limit: 11
    t.string   "email",                             default: "",        null: false
    t.string   "encrypted_password",                default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname",                          default: ""
    t.string   "zendesk_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["id"], name: "id", unique: true, using: :btree
  add_index "users", ["name"], name: "name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
