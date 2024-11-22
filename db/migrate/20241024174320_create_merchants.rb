# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[7.2]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :email, null: false
      t.date :live_on, null: false
      t.string :reference, null: false, index: { unique: true }
      t.integer :disbursement_frequency, default: 0, null: false
      t.bigint :minimum_monthly_fee_cents, null: false

      t.timestamps
    end
  end
end
