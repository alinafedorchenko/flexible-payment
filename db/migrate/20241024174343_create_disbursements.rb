# frozen_string_literal: true

class CreateDisbursements < ActiveRecord::Migration[7.2]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.bigint :amount_cents, null: false
      t.bigint :fee_cents, null: false
      t.bigint :monthly_fee_cents, null: false, default: 0
      t.references :merchant, null: false, foreign_key: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
