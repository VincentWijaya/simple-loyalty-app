class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :customerId
      t.string :customerName
      t.string :orderId
      t.integer :totalInCents
      t.datetime :date

      t.timestamps
    end
  end
end
