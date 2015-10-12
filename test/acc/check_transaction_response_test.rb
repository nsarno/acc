require 'test_helper'
require 'json'

class Acc::CheckTransactionResponseTest < Minitest::Test
  def setup
    @acc_response = JSON.parse <<-EOT
      {
        "deviceEnrollmentTransactionID": "cf0ecb03-2993-479b-a891-9e973d3ec6ec_1413530075665",
        "completedOn": "2014-10-17T07:14:39Z",
        "orders": [
            {
                "orderNumber": "ORDER_900123",
                "orderPostStatus": "COMPLETE",
                "deliveries": [
                    {
                        "deliveryNumber": "D1.2",
                        "deliveryPostStatus": "COMPLETE",
                        "devices": [
                            {
                                "deviceId": "33645004YAM",
                                "devicePostStatus": "COMPLETE"
                            },
                            {
                                "deviceId": "33645006YAM",
                                "devicePostStatus": "COMPLETE"
                            }
                        ]
                    }
                ]
            }
        ],
        "statusCode": "COMPLETE"
      }
    EOT
    @acc_ship_to_error_response = JSON.parse <<-EOT
      {
        "errorCode": "GRX-50025",
        "errorMessage": "Ship-To entered is not valid. Please enter a valid Ship-To",
        "transactionId": "13836d68-7353-4acc-a813-0e217be8f04d-1424990915792"
      }
    EOT
    @acc_order_error_response = JSON.parse <<-EOT
      {
        "deviceEnrollmentTransactionID": "9acc1cf5-e41d-44d4-a066-78162a389da2_1413529391461",
        "completedOn": "2014-10-17T07:03:15Z",
        "orders": [
            {
                "orderNumber": "ORDER_900123",
                "orderPostStatus": "ERROR",
                "deliveries": [
                    {
                        "deliveryNumber": "D1.2",
                        "deliveryPostStatus": "ERROR",
                        "devices": [
                            {
                                "deviceId": "CQ115U05PKK",
                                "devicePostStatus": "DEP-ERR-DE-4305",
                                "devicePostStatusMessage": "Device unavailable. The device is assigned to another reseller for a different normal (OR) or override (OV) order. Try using a different device ID and resubmit your request."
                            },
                            {
                                "deviceId": "CQ115U06PKK",
                                "devicePostStatus": "DEP-ERR-DE-4305",
                                "devicePostStatusMessage": "Device unavailable. The device is assigned to another reseller for a different normal (OR) or override (OV) order. Try using a different device ID and resubmit your request."
                            }
                        ]
                    }
                ]
            }
        ],
        "statusCode": "ERROR"
      }
    EOT
    @acc_single_error_response = JSON.parse <<-EOT
      {
        "checkTransactionErrorResponse": {
            "errorMessage": "Access denied. You do not have permission to act on behalf of the Device Enrollment Program reseller ID.",
            "errorCode": "GRX-90004"
        }
      }
    EOT
    @acc_multiple_error_response = JSON.parse <<-EOT
      {
          "checkTransactionErrorResponse": [
             {
                  "errorCode": "GRX-1056",
                  "errorMessage": "DEP Reseller ID missing. Enter a valid DEP Reseller ID and resubmit your request."
              },
              {
                  "errorCode": "DEP-ERR-4001",
                  "errorMessage": "Device Enrollment Program Transaction ID missing. Enter a valid transaction ID (for example,d813a291-996b-49c3-b09a-6906eced573e_1411422020272) and resubmit your request."
              }
          ]
      }
    EOT
  end

  def test_it_parses_valid_response
    resp = Acc::CheckTransactionResponse.new(@acc_response)
    assert_equal resp.error?, false
    assert_equal resp.success?, true
    assert_equal resp.error_messages.any?, false
    assert_equal resp.data, @acc_response
  end

  def test_it_parses_ship_to_error_response
    resp = Acc::CheckTransactionResponse.new(@acc_ship_to_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 1
    assert_equal resp.data, @acc_ship_to_error_response
  end

  def test_it_parses_order_error_response
    resp = Acc::CheckTransactionResponse.new(@acc_order_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 0
    assert_equal resp.data, @acc_order_error_response    
  end

  def test_it_parses_single_error_response
    resp = Acc::CheckTransactionResponse.new(@acc_single_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 1
    assert_equal resp.data, @acc_single_error_response
  end

  def test_it_parses_mutliple_error_response
    resp = Acc::CheckTransactionResponse.new(@acc_multiple_error_response)
    assert_equal resp.error?, true
    assert_equal resp.success?, false
    assert_equal resp.error_messages.count, 2
    assert_equal resp.data, @acc_multiple_error_response
  end
end
