require 'csv'
require 'securerandom'

unless User.merchants.any?
  merchants_data = []
  CSV.foreach('./db/seeds/s-and-p-500-companies.csv', headers: true) do |row|
    email = "#{SecureRandom.hex(8)}@merchant.org"
    merchants_data << {
      name: row['Name'],
      role: User.roles[:merchant],
      email: email
    }
  end
  User.import!(merchants_data)
end
