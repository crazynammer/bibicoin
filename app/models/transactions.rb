class Transactions < ActiveRecord::Base
	has_one: transaction_types
end
