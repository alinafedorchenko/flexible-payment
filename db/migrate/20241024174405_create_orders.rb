class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders, id: :uuid do |t|
      t.bigint :amount_cents, null: false
      t.integer :status, default: 0, null: false, index: true
      t.references :disbursement, foreign_key: true, index: true, type: :uuid
      t.references :merchant, null: false, foreign_key: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
