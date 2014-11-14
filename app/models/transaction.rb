class Transaction < ActiveRecord::Base

	has_one :transaction_type, :inverse_of => :transaction
	
	validates :transaction_type_id, presence: true
	validates :walletID, presence: true
	validates :name, presence: true
	validates :email, presence: true
	validates :DoB, presence: true
	validates :BTCAmt, presence: true
	validates :TWDAmt, presence: true, :numericality => { :greater_than_or_equal_to => 3000, :less_than_or_equal_to => 30000, :message => "Must be between 3000 and 30000 NTD" }
	validates :commAmt, presence: true
	validates :commRate, presence: true
	#validates :orderDate
	#validates :moneyReceivedDate
	#validates :BTCReceivedDate
	validates :bankName, presence: true
	validates :bankAcctNumber, presence: true
	validates :marketBTCtoUSDRate, presence: true
    validates :marketBTCtoRMBRate, presence: true 
    validates :marketBTCtoHKDRate, presence: true
    validates :marketBTCtoEURRate, presence: true
    validates :fxRateUSDtoTWD, presence: true
    validates :fxRateRMBtoTWD, presence: true
    validates :fxRateHKDtoTWD, presence: true
    validates :fxRateEURtoTWD, presence: true
    validates :bibicoinBTCtoTWD, presence: true
	validates :agreeTerms, acceptance: true
	#validates :isComplete
	
	validates_associated :transaction_type_id

	
	
end
