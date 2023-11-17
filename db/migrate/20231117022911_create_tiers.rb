class CreateTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :tiers do |t|
      t.string :name
      t.integer :minSpent

      t.timestamps
    end
  end
end
