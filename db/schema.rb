# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_30_033946) do

  create_table "cells", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "x"
    t.integer "y"
    t.string "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_cells_on_game_id"
  end

  create_table "gamers", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.string "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_gamers_on_game_id"
    t.index ["user_id"], name: "index_gamers_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "winner_id"
    t.string "state"
    t.integer "dimension"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "gamer_id", null: false
    t.integer "cell_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cell_id"], name: "index_steps_on_cell_id"
    t.index ["game_id"], name: "index_steps_on_game_id"
    t.index ["gamer_id"], name: "index_steps_on_gamer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cells", "games"
  add_foreign_key "gamers", "games"
  add_foreign_key "gamers", "users"
  add_foreign_key "games", "users"
  add_foreign_key "steps", "cells"
  add_foreign_key "steps", "gamers"
  add_foreign_key "steps", "games"
end
