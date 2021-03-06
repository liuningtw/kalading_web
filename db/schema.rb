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

ActiveRecord::Schema.define(version: 20150512070107) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "impressions_count", default: 0
    t.string   "preferential_code"
    t.string   "from"
  end

  create_table "activity_products", force: true do |t|
    t.integer  "activity_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_products", ["activity_id"], name: "index_activity_products_on_activity_id", using: :btree
  add_index "activity_products", ["product_id"], name: "index_activity_products_on_product_id", using: :btree

  create_table "auth_infos", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "expires_at"
    t.integer  "public_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_infos", ["provider", "uid"], name: "index_auth_infos_on_provider_and_uid", using: :btree
  add_index "auth_infos", ["uid"], name: "index_auth_infos_on_uid", using: :btree

  create_table "authinfo_activities", force: true do |t|
    t.integer  "auth_info_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "share_authinfo_id"
  end

  create_table "autos", force: true do |t|
    t.string   "system_id"
    t.string   "brand"
    t.string   "series"
    t.string   "model_number"
    t.date     "registed_at"
    t.string   "engine_number"
    t.string   "vin"
    t.string   "license_location"
    t.string   "license_number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
  end

  add_index "autos", ["user_id"], name: "index_autos_on_user_id", using: :btree

  create_table "channels", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.string   "system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "district_desc"
  end

  create_table "city_products", force: true do |t|
    t.integer  "city_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "city_products", ["city_id"], name: "index_city_products_on_city_id", using: :btree
  add_index "city_products", ["product_id"], name: "index_city_products_on_product_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "diymenus", force: true do |t|
    t.integer  "public_account_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.boolean  "is_show"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diymenus", ["key"], name: "index_diymenus_on_key", using: :btree
  add_index "diymenus", ["parent_id"], name: "index_diymenus_on_parent_id", using: :btree
  add_index "diymenus", ["public_account_id"], name: "index_diymenus_on_public_account_id", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "pay_infos", force: true do |t|
    t.string   "transaction_id"
    t.string   "out_trade_no"
    t.string   "total_fee"
    t.datetime "time_end"
    t.string   "trade_type"
    t.string   "fee_type"
    t.string   "bank_type"
    t.string   "result_code"
    t.integer  "auth_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cash_fee"
    t.string   "return_code"
  end

  add_index "pay_infos", ["auth_info_id"], name: "index_pay_infos_on_auth_info_id", using: :btree
  add_index "pay_infos", ["transaction_id"], name: "index_pay_infos_on_transaction_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "public_accounts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_id"
    t.string   "appid"
    t.string   "appsecret"
    t.string   "name"
    t.string   "account_secret_key"
    t.string   "account_token"
    t.string   "access_token"
    t.string   "jsapi_ticket"
    t.datetime "token_expires_at"
    t.datetime "ticket_expires_at"
  end

  add_index "public_accounts", ["account_id"], name: "index_public_accounts_on_account_id", unique: true, using: :btree
  add_index "public_accounts", ["account_secret_key"], name: "index_public_accounts_on_account_secret_key", using: :btree
  add_index "public_accounts", ["account_token"], name: "index_public_accounts_on_account_token", using: :btree
  add_index "public_accounts", ["name"], name: "index_public_accounts_on_name", unique: true, using: :btree

  create_table "recv_messages", force: true do |t|
    t.string   "from_user_name"
    t.string   "msg_type"
    t.text     "content"
    t.string   "msg_id"
    t.string   "pic_url"
    t.string   "media_id"
    t.string   "format"
    t.string   "thumb_media_id"
    t.string   "location_x"
    t.string   "location_y"
    t.string   "scale"
    t.string   "label"
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "public_account_id"
  end

  add_index "recv_messages", ["msg_id"], name: "index_recv_messages_on_msg_id", unique: true, using: :btree

  create_table "reply_articles", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "pic"
    t.string   "url"
    t.integer  "reply_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reply_articles", ["reply_message_id"], name: "index_reply_articles_on_reply_message_id", using: :btree

  create_table "reply_messages", force: true do |t|
    t.string   "msg_type"
    t.text     "content"
    t.string   "media_id"
    t.string   "music_url"
    t.string   "hq_music_url"
    t.string   "thumb_media_id"
    t.integer  "public_account_id"
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reply_messages", ["keyword"], name: "index_reply_messages_on_keyword", using: :btree

  create_table "service_addresses", force: true do |t|
    t.string   "city"
    t.string   "detail"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "district"
  end

  add_index "service_addresses", ["user_id"], name: "index_service_addresses_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_authinfos", force: true do |t|
    t.integer  "user_id"
    t.integer  "auth_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "phone_number"
    t.integer  "city_id"
    t.integer  "default_address_id"
    t.string   "username"
    t.string   "invoice_title"
    t.datetime "expires_at"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["default_address_id"], name: "index_users_on_default_address_id", using: :btree
  add_index "users", ["token"], name: "index_users_on_token", using: :btree

  create_table "verification_codes", force: true do |t|
    t.string   "phone_num"
    t.string   "code"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "verification_codes", ["code"], name: "index_verification_codes_on_code", using: :btree
  add_index "verification_codes", ["phone_num"], name: "index_verification_codes_on_phone_num", using: :btree

end
