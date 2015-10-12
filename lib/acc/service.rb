require 'curb'
require 'json'

class Acc::Service
  def bulk_enroll data
    http_resp = request(Acc.bulk_enroll_endpoint, data)
    Acc::BulkEnrollResponse.new JSON.parse(http_resp.body_str)
  end

  def check_transaction_status data
    http_resp = request(Acc.check_transaction_endpoint, data)
    Acc::CheckTransactionResponse.new JSON.parse(http_resp.body_str)
  end

  def show_order_details data
    http_resp = request(Acc.show_order_endpoint, data)
    puts http_resp
    JSON.parse(http_resp.body_str)
  end

  private
    def request url, data
      http_response = Curl::Easy.perform(url) do |req|
        req.certpassword = Acc.certificate_password
        req.cert = Acc.certificate
        req.post_body = data
        req.headers['Content-Type'] = 'application/json'
      end
    end
end
