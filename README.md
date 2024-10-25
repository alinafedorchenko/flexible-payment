# README

# Context

seQura provides e-commerce shops with a flexible payment method that allows shoppers to split their purchases in three months without any cost. In exchange, seQura earns a fee for each purchase.

When shoppers use this payment method, they pay directly to seQura. Then, seQura disburses the orders to merchants with different frequencies and pricing.

This challenge is about implementing the process of paying merchants.

# Setup

Make sure you have Docker and Docker Compose installed on your machine before starting.
You can access your application at http://localhost:3000 after the containers are up and running.

`git clone git@github.com:alinafedorchenko/flexible-payment.git`

`cd flexible-payment`

`docker-compose up --build`

`docker-compose run web rails db:create db:migrate`

To fill the database from CSV files, run this task:

`docker-compose run web rake import:all`

To disburse old orders, run this task:

`docker-compose run web rake orders:disburse_all`

To generate an annual report, run this task:

`docker-compose run web rake report:yearly`

<img width="1243" alt="Screenshot 2024-10-25 at 17 13 37" src="https://github.com/user-attachments/assets/5bfd0969-ce3d-457e-8d93-1d679b2c2660">


# Additional Information

**Monetary Precision**: The application employs amounts in cents, ensuring accurate financial calculations and eliminating potential rounding errors.

**Model Implementation**: The application includes the following models:

* Merchant: Represents the stores or businesses in the payment system. Each merchant has an email, a unique reference, a live_on date, and a minimum monthly fee in cents. Merchants also have a schedule for how often they receive payments.

* Order: Records individual transactions made through the platform. Each order includes the amount in cents, its status, and links to the related merchant and disbursement.

* Disbursement: Handles the payments made to merchants based on pending payment orders. It keeps track of the total amount paid in cents, any fees (including monthly fees), and connects to the merchant receiving the payment.

**Asynchronous Processing**: Sidekiq is used for managing background jobs, allowing long tasks to run without slowing down the main application.

**Automated Scheduling**: Sidekiq-Scheduler runs daily jobs at 5 AM, automatically handling routine tasks and making sure everything runs on time without needing manual input.

# Improvements

* Add More Tests: Increase the test coverage to ensure all features work correctly.
* Improve Importer Efficiency: If there are more imports in the future, we will need a more efficient importer to handle larger datasets.
* Report Export: Implement functionality to export report to CSV and consider sending it via email.
* Separate Logic for Monthly Fee Calculation: Consider breaking out the logic for calculating the monthly fee to improve code organization and readability.
* Handling Dates in Timezone: To ensure that all date and time handling is done with proper timezone support.
* Consider Rounding Half to Even: Implement rounding half to even for amounts to improve accuracy and compliance with financial standards.
