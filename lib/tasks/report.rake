# frozen_string_literal: true

# rubocop:disable Style/FormatStringToken
namespace :report do
  # TODO: Consider export report to csv and cache results.
  desc 'Generate yearly disbursement report'
  task yearly: :environment do
    report_data = Disbursement.select(
      'EXTRACT(YEAR FROM created_at) AS year',
      'COUNT(*) AS number_of_disbursements',
      'SUM(amount_cents) AS total_amount_disbursed',
      'SUM(fee_cents) AS total_order_fees',
      'COUNT(CASE WHEN monthly_fee_cents > 0 THEN 1 END) AS number_of_monthly_fees',
      'SUM(monthly_fee_cents) AS total_monthly_fees'
    ).group('EXTRACT(YEAR FROM created_at)').order('year')

    puts '-' * 160
    puts format(
      '| %-4s | %-23s | %-29s | %-18s | %-30s | %-28s |',
      'Year', 'Number of disbursements', 'Amount disbursed to merchants', 'Amount of order fees', 'Number of monthly fees charged', 'Amount of monthly fee charged'
    )
    puts '-' * 160

    report_data.each do |data|
      year = data.year.to_i
      number_of_disbursements = data.number_of_disbursements
      total_amount_disbursed = data.total_amount_disbursed.to_f / 100
      total_order_fees = data.total_order_fees.to_f / 100
      number_of_monthly_fees = data.number_of_monthly_fees
      total_monthly_fees = data.total_monthly_fees.to_f / 100

      puts format(
        '| %-4s | %-23s | %-29s | %-20s | %-30s | %-29s |',
        year,
        number_of_disbursements,
        format('%.2f €', total_amount_disbursed),
        format('%.2f €', total_order_fees),
        number_of_monthly_fees,
        format('%.2f €', total_monthly_fees)
      )
    end

    puts '-' * 160
  end
end
# rubocop:enable Style/FormatStringToken
