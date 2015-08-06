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

ActiveRecord::Schema.define(version: 20150806033118) do

  create_table "boards", force: :cascade do |t|
    t.integer  "round_number", limit: 4,                   null: false
    t.boolean  "finished",     limit: 1,   default: false, null: false
    t.string   "serialized",   limit: 255,                 null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "game_id",      limit: 4,                   null: false
    t.datetime "finished_at"
  end

  add_index "boards", ["finished"], name: "index_boards_on_finished", using: :btree
  add_index "boards", ["game_id"], name: "index_boards_on_game_id", using: :btree
  add_index "boards", ["round_number"], name: "index_boards_on_round_number", using: :btree

  create_table "dictionaries", force: :cascade do |t|
    t.string   "word",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "dictionaries", ["word"], name: "index_dictionaries_on_word", using: :btree

  create_table "games", force: :cascade do |t|
    t.boolean  "started",    limit: 1, default: false, null: false
    t.boolean  "finished",   limit: 1, default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "games", ["finished"], name: "index_games_on_finished", using: :btree
  add_index "games", ["started"], name: "index_games_on_started", using: :btree

  create_table "guesses", force: :cascade do |t|
    t.integer  "player_id",     limit: 4,                   null: false
    t.integer  "board_id",      limit: 4,                   null: false
    t.string   "word",          limit: 255,                 null: false
    t.boolean  "possible",      limit: 1
    t.boolean  "checked",       limit: 1,   default: false, null: false
    t.boolean  "unique",        limit: 1
    t.integer  "score",         limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "in_dictionary", limit: 1
  end

  add_index "guesses", ["board_id"], name: "index_guesses_on_board_id", using: :btree
  add_index "guesses", ["player_id"], name: "index_guesses_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                 null: false
    t.integer  "score",      limit: 4, default: 0,     null: false
    t.boolean  "ready",      limit: 1, default: false, null: false
    t.boolean  "finished",   limit: 1, default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "game_id",    limit: 4,                 null: false
    t.boolean  "guessed",    limit: 1, default: false, null: false
  end

  add_index "players", ["finished"], name: "index_players_on_finished", using: :btree
  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["guessed"], name: "index_players_on_guessed", using: :btree
  add_index "players", ["ready"], name: "index_players_on_ready", using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",      limit: 255
    t.string   "uid",           limit: 255
    t.string   "name",          limit: 255
    t.string   "refresh_token", limit: 255
    t.string   "access_token",  limit: 255
    t.datetime "expires"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "boards", "games"
  add_foreign_key "guesses", "boards"
  add_foreign_key "guesses", "players"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
end
