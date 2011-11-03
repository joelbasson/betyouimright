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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111103203818) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer   "resource_id",   :null => false
    t.string    "resource_type", :null => false
    t.integer   "author_id"
    t.string    "author_type"
    t.text      "body"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string    "email",                               :default => "", :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer   "user_id"
    t.string    "provider"
    t.string    "uid"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "awards_wallets", :id => false, :force => true do |t|
    t.integer   "award_id"
    t.integer   "wallet_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "awards_wallets", ["award_id", "wallet_id"], :name => "index_awards_wallets_on_award_id_and_wallet_id", :unique => true

  create_table "bet_categories", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "bets", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.timestamp "end_date"
    t.integer   "wager_amount"
    t.text      "verify_description"
    t.boolean   "verified",           :default => false
    t.boolean   "confirmed",          :default => false
    t.string    "status",             :default => "Undecided"
    t.integer   "user_id"
    t.integer   "wagers_count",       :default => 0
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "bet_category_id"
    t.integer   "comments_count",     :default => 0
    t.string    "visibility"
    t.integer   "challengee_id"
  end

  add_index "bets", ["bet_category_id"], :name => "index_bets_on_bet_category_id"
  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"

  create_table "bonuses", :force => true do |t|
    t.string    "name"
    t.string    "short_description"
    t.text      "description"
    t.string    "rule"
    t.text      "rule_description"
    t.string    "activation"
    t.integer   "credits",           :default => 0
    t.integer   "target",            :default => 0
    t.string    "beneficiary",       :default => "Winners"
    t.string    "bonustype",         :default => "WagersTotal"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "cashouts", :force => true do |t|
    t.integer   "wallet_id"
    t.integer   "amount"
    t.string    "paypal_email"
    t.decimal   "value"
    t.integer   "user_id"
    t.timestamp "completed_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "return_message"
  end

  add_index "cashouts", ["user_id"], :name => "index_cashouts_on_user_id"
  add_index "cashouts", ["wallet_id"], :name => "index_cashouts_on_wallet_id"

  create_table "categories", :force => true do |t|
    t.string    "title"
    t.boolean   "state",      :default => true
    t.integer   "position",   :default => 0
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer   "user_id"
    t.text      "body"
    t.integer   "commentable_id"
    t.string    "commentable_type"
    t.boolean   "is_spam"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "comments_count",   :default => 0
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at"
    t.timestamp "locked_at"
    t.timestamp "failed_at"
    t.string    "locked_by"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "forums", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.boolean   "state",        :default => true
    t.integer   "topics_count", :default => 0
    t.integer   "posts_count",  :default => 0
    t.integer   "position",     :default => 0
    t.integer   "category_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer   "user_id"
    t.integer   "friend_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string    "title"
    t.text      "message"
    t.integer   "user_id"
    t.boolean   "viewed",     :default => false
    t.boolean   "closed",     :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "payment_notifications", :force => true do |t|
    t.text      "params"
    t.integer   "purchase_id"
    t.string    "status"
    t.string    "transaction_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "payment_notifications", ["purchase_id"], :name => "index_payment_notifications_on_purchase_id"
  add_index "payment_notifications", ["transaction_id"], :name => "index_payment_notifications_on_transaction_id"

  create_table "posts", :force => true do |t|
    t.text      "body"
    t.integer   "forum_id"
    t.integer   "topic_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "purchases", :force => true do |t|
    t.integer   "wallet_id"
    t.integer   "amount"
    t.integer   "user_id"
    t.decimal   "value"
    t.timestamp "purchased_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "purchases", ["user_id"], :name => "index_purchases_on_user_id"
  add_index "purchases", ["wallet_id"], :name => "index_purchases_on_wallet_id"

  create_table "topics", :force => true do |t|
    t.string    "title"
    t.integer   "hits",        :default => 0
    t.boolean   "sticky",      :default => false
    t.boolean   "locked",      :default => false
    t.integer   "posts_count"
    t.integer   "forum_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "bet_id"
  end

  create_table "transactions", :force => true do |t|
    t.integer   "wallet_id"
    t.string    "description"
    t.integer   "bet_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "transactions", ["bet_id"], :name => "index_transactions_on_bet_id"
  add_index "transactions", ["wallet_id"], :name => "index_transactions_on_wallet_id"

  create_table "users", :force => true do |t|
    t.string    "email",                               :default => "",    :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string    "password_salt",                       :default => "",    :null => false
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.integer   "wallet_id"
    t.string    "display_name"
    t.boolean   "admin",                               :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "topics_count",                        :default => 0
    t.integer   "posts_count",                         :default => 0
    t.string    "profile"
    t.string    "fbidentifier"
    t.string    "fbtoken"
    t.timestamp "fbtoken_updated_at"
    t.text      "fbfriendscollection"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["wallet_id"], :name => "index_users_on_wallet_id"

  create_table "wagers", :force => true do |t|
    t.integer   "user_id"
    t.integer   "bet_id"
    t.boolean   "against",    :default => false
    t.integer   "credits",    :default => 10
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "wagers", ["bet_id"], :name => "index_wagers_on_bet_id"
  add_index "wagers", ["user_id"], :name => "index_wagers_on_user_id"

  create_table "wallets", :force => true do |t|
    t.integer   "credits"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "score",      :default => 0
    t.timestamp "pointtime",  :default => '2011-04-01 04:27:29'
  end

end
