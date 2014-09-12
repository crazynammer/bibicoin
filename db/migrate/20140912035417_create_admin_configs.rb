class CreateAdminConfigs < ActiveRecord::Migration
  def change
    create_table :admin_configs do |t|
      t.text :adminID
      t.string :bankInfo
      t.text :defaultCurrency
      t.text :email
      t.decimal :commRateBuy1
      t.decimal :commRateBuy2
      t.decimal :commRateBuy3
      t.decimal :commRateSell1
      t.decimal :commRateSell2
      t.decimal :commRateSell3
      t.text :adminWalletID

      t.timestamps
    end
  end
end
