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

ActiveRecord::Schema.define(version: 2020_12_14_101432) do

  create_table "temperature_states", force: :cascade do |t|
    t.integer "location_id", null: false
    t.text "temperature_data", null: false
    t.integer "datetime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_temperature_states_on_datetime"
    t.index ["location_id"], name: "index_temperature_states_on_location_id"
  end

  create_table "weather_request_logs", force: :cascade do |t|
    t.string "location_id", null: false
    t.string "response_code"
    t.text "response_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_weather_request_logs_on_location_id"
  end

end
