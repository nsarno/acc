require 'curb'

class ACC::Service
  def initialize
    @cert_path = File.join(Rails.root, ACC::CERTIFICATE_PATH)
    raise 'Invalid path to certificate' unless File.file?(@cert_path)
  end

  def bulk_enroll data
    http_resp = request(ACC::BULK_ENROLL_URL, data)
    ACC::BulkEnrollResponse.new JSON.parse(http_resp.body_str)
  end

  def check_transaction_status data
    http_resp = request(ACC::CHECK_TRANSACTION_URL, data)
    ACC::CheckTransactionResponse.new JSON.parse(http_resp.body_str)
  end

  def show_order_details data
    puts 'SHOW ORDER DETAILS'
    http_resp = request(ACC::SHOW_ORDER_URL, data)
    puts http_resp
    JSON.parse(http_resp.body_str)
  end

  private
    def request url, data
      http_response = Curl::Easy.perform(url) do |req|
        req.certpassword = 'Password123'
        req.cert = @cert_path
        req.post_body = data
        req.headers['Content-Type'] = 'application/json'
      end
    end
end
