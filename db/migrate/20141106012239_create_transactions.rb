class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :transaction_type_id
      t.string :walletID
      t.string :name
      t.string :email
      t.date :DoB
      t.decimal :BTCAmt
      t.decimal :TWDAmt
      t.decimal :commAmt
      t.decimal :commRate
      t.datetime :orderDate
      t.datetime :moneyReceivedDate
      t.datetime :BTCReceivedDate
      t.text :bankName
      t.text :bankAcctNumber
      t.decimal :marketBTCtoUSDRate
      t.decimal :marketBTCtoRMBRate
      t.decimal :marketBTCtoHKDRate
      t.decimal :marketBTCtoEURRate
      t.decimal :fxRateUSDtoTWD
      t.decimal :fxRateRMBtoTWD
      t.decimal :fxRateHKDtoTWD
      t.decimal :fxRateEURtoTWD
      t.decimal :bibicoinBTCtoTWD
      t.boolean :agreeTerms
      t.boolean :isComplete

      t.timestamps
    end
  end
end
