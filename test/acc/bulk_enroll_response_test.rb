require 'test_helper'
require 'json'

class Acc::BulkEnrollResponseTest < Minitest::Test
  def setup
    @acc_response = JSON.parse <<-EOT
      {
        "deviceEnrollmentTransactionId": "9acc1cf5-e41d-44d4-a066-78162a389da2_1413529391461",
        "enrollDevicesResponse": {
          "statusCode": "SUCCESS",
          "statusMessage": "Transaction posted successfully in DEP"
        }
      }
    EOT
    @acc_ship_to_error_response = JSON.parse <<-EOT
      {
        "errorCode": "GRX-50025",
        "errorMessage": "Ship-To entered is not valid. Please enter a valid Ship-To",
        "transactionId": "13836d68-7353-4acc-a813-0e217be8f04d-1424990915792"
      }
    EOT
    @acc_single_error_response = JSON.parse <<-EOT
      {
        "enrollDeviceErrorResponse": {
          "errorCode": "GRX-1056",
          "errorMessage": "DEP Reseller ID missing. Enter a valid DEP Reseller ID and resubmit your request."
        }
      }
    EOT
    @acc_multiple_error_response = JSON.parse <<-EOT
      {
        "enrollDeviceErrorResponse": [
          {
            "errorCode": "GRX-1056",
            "errorMessage": "DEP Reseller ID missing. Enter a valid DEP Reseller ID and resubmit your request."
          },
          {
              "errorCode": "DEP-ERR-3003",
              "errorMessage": "Order information missing. The transaction needs to have one or more valid orders. Enter valid orders and resubmit your request."
          },
          {
              "errorCode": "DEP-ERR-3001",
              "errorMessage": "Transaction ID missing. Enter a valid transaction ID and resubmit your request."
          }
        ]
      }
    EOT
  end

  def test_it_parses_valid_response
    resp = Acc::BulkEnrollResponse.new(@acc_response)
    assert_equal resp.error?, false
    assert_equal resp.success?, true
    assert_equal resp.error_messages.any?, false
    assert_equal resp.data, {
      dep_transaction_id: "9acc1cf5-e41d-44d4-a066-78162a389da2_1413529391461",
      status_message: "Transaction posted successfully in DEP"
    }
  end

  def test_it_parses_ship_to_error_response
    resp = Acc::BulkEnrollResponse.new(@acc_ship_to_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 1
    assert_equal resp.data, nil
  end

  def test_it_parses_single_error_response
    resp = Acc::BulkEnrollResponse.new(@acc_single_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 1
    assert_equal resp.data, nil
  end

  def test_it_parses_mutliple_error_response
    resp = Acc::BulkEnrollResponse.new(@acc_multiple_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 3
    assert_equal resp.data, nil
  end
end
