require 'acc/version'
require 'active_support'

module Acc
  mattr_accessor :bulk_enroll_endpoint
  self.bulk_enroll_endpoint = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/bulk-enroll-devices'

  mattr_accessor :check_transaction_endpoint
  self.check_transaction_endpoint = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/check-transaction-status'

  mattr_accessor :show_order_endpoint
  self.show_order_endpoint = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/show-order-details'

  mattr_accessor :certificate
  mattr_accessor :certificate_password

  def self.setup
    yield self
  end
end

require 'acc/bulk_enroll_response'
require 'acc/check_transaction_response'
require 'acc/service'
