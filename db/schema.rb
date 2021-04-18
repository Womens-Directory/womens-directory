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

ActiveRecord::Schema.define(version: 2021_04_18_002858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_locations", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "location_id", null: false
    t.index ["category_id", "location_id"], name: "index_categories_locations_on_category_id_and_location_id"
    t.index ["location_id", "category_id"], name: "index_categories_locations_on_location_id_and_category_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "neighborhood"
    t.string "address1"
    t.string "address2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.text "desc", null: false
    t.bigint "org_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["org_id"], name: "index_locations_on_org_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name", null: false
    t.string "website", null: false
    t.text "desc", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "locations", "orgs"
end
