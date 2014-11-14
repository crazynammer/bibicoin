class TransactionType < ActiveRecord::Base
	belongs_to :transaction, :inverse_of => :transaction_type
end
