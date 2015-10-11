require "acc/version"

module Acc
  BULK_ENROLL_URL = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/bulk-enroll-devices'
  CHECK_TRANSACTION_URL = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/check-transaction-status'
  SHOW_ORDER_URL = 'https://api-applecareconnect-ept.apple.com/enroll-service/1.0/show-order-details'
  CERTIFICATE_PATH = Rails.env.production? ? 'config/certificate.pem' : 'config/certificate.pfx'
end

require 'acc/bulk_enroll_response'
require 'acc/check_transaction_response'
require 'acc/service'
