class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :customerId
      t.string :customerName
      t.integer :tierId

      t.timestamps
    end
  end
end
