class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :transaction_types_id
      t.text :walletID
      t.text :name
      t.text :email
      t.date :dob
      t.decimal :BTCAmt
      t.decimal :BTCtoTWDAmt
      t.decimal :CommAmt
      t.decimal :CommRate
      t.datetime :OrderDate
      t.datetime :moneyReceivedDate
      t.datetime :BTCreceivedDate
      t.text :bankName
      t.text :bankAcctNumber
      t.decimal :marketBTCtoUSDRate
      t.decimal :marketBTCtoRMBRate
      t.decimal :marketBTCtoHKDRate
      t.decimal :marketBTCtoEURate
      t.decimal :fxRateUSDtoTWD
      t.decimal :fxRateRMBtoTWD
      t.decimal :fxRateHKDtoTWD
      t.decimal :fxRateEURtoTWD
      t.decimal :bibicoinBTCtoTWD
      t.boolean :isComplete

      t.timestamps
    end
  end
end
