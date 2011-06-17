class Transaction < ActiveRecord::Base
  belongs_to :wallet
  belongs_to :bet
end
