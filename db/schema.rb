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

ActiveRecord::Schema[7.0].define(version: 2022_06_01_175041) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image_data"
    t.integer "tracks_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image_data"
    t.integer "stories_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "story_id"
    t.integer "start_min"
    t.integer "end_min"
    t.integer "user_id"
    t.integer "identified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identified_by"], name: "index_playlists_on_identified_by"
    t.index ["story_id"], name: "index_playlists_on_story_id"
    t.index ["track_id"], name: "index_playlists_on_track_id"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image_data"
    t.boolean "completed"
    t.date "date"
    t.integer "radio"
    t.jsonb "json_field", default: {}
    t.integer "playlists_count", default: 0
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_stories_on_author_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image_data"
    t.bigint "artist_id"
    t.integer "playlists_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.text "avatar_data"
    t.string "username", null: false
    t.integer "role", default: 0
    t.integer "playlists_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
