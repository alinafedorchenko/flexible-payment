require 'csv'

namespace :import do
  desc "Import merchants"
  task merchants: :environment do
    p "Merchants import started!"

    filename = Rails.root.join('lib/seeds/merchants.csv')
    merchants = []

    CSV.foreach(filename, headers: true, col_sep: ';') do |row|
      merchants << merchant_data(row)
    end

    result = Merchant.import! merchants
    p "#{result.failed_instances.size} merchant records failed to import."
    p "#{result.ids.size} merchants were imported."
  end

  desc "Import orders"
  task orders: :environment do
    p "Orders import started!"

    filename = Rails.root.join('lib/seeds/orders.csv')
    orders = []

    CSV.foreach(filename, headers: true, col_sep: ';') do |row|
      orders << order_data(row)
    end

    result = Order.import! orders
    p "#{result.failed_instances.size} order records failed to import."
    p "#{result.ids.size} orders were imported."
  end

  desc "import all"
  task all: :environment do
    Rake::Task['import:merchants'].execute
    Rake::Task['import:orders'].execute
  end

  private

  def merchant_data(row)
    {
      reference: row['reference'],
      email: row['email'],
      live_on: Date.parse(row['live_on']),
      disbursement_frequency: row['disbursement_frequency'].downcase.to_sym,
      minimum_monthly_fee_cents: convert_to_cents(row['minimum_monthly_fee']),
    }
  end

  def order_data(row)
    {
      amount_cents: convert_to_cents(row['amount']),
      merchant_id: merchants_map[row['merchant_reference']],
      created_at: DateTime.parse(row['created_at'])
    }
  end

  def convert_to_cents(amount)
    (amount.to_f * 100).to_i
  end

  def merchants_map
    @merchants_map ||= Merchant.all.pluck(:reference, :id).to_h
  end
end