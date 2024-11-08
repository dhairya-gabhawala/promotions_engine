# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_08_140138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "conditions", force: :cascade do |t|
    t.bigint "promotion_id", null: false
    t.string "by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promotion_id"], name: "index_conditions_on_promotion_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "condition_id", null: false
    t.string "by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_groups_on_condition_id"
  end

  create_table "operations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "variable_key"
    t.string "operator"
    t.string "constant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_operations_on_group_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.string "sku", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "sku"], name: "index_products_on_property_id_and_sku", unique: true
    t.index ["property_id"], name: "index_products_on_property_id"
  end

  create_table "products_promotions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "promotion_id", null: false
    t.string "relationship", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "promotion_id"], name: "index_products_promotions_on_product_id_and_promotion_id", unique: true
    t.index ["product_id"], name: "index_products_promotions_on_product_id"
    t.index ["promotion_id"], name: "index_products_promotions_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.date "start"
    t.date "end"
    t.string "link", null: false
    t.integer "rank", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "code"], name: "index_promotions_on_property_id_and_code", unique: true
    t.index ["property_id"], name: "index_promotions_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name", null: false
    t.string "api_key", null: false
    t.string "secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_properties_on_api_key", unique: true
    t.index ["secret"], name: "index_properties_on_secret", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variables", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.string "name", null: false
    t.string "key", null: false
    t.string "description", null: false
    t.integer "value_type", default: 0, null: false
    t.string "possible_values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "key"], name: "index_variables_on_property_id_and_key", unique: true
    t.index ["property_id"], name: "index_variables_on_property_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conditions", "promotions"
  add_foreign_key "groups", "conditions"
  add_foreign_key "operations", "groups"
  add_foreign_key "products", "properties"
  add_foreign_key "products_promotions", "products"
  add_foreign_key "products_promotions", "promotions"
  add_foreign_key "promotions", "properties"
  add_foreign_key "variables", "properties"
end
