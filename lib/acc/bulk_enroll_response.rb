class Acc::BulkEnrollResponse
  def initialize json_response
    @response = json_response
  end

  def error?
    !error_response.nil?
  end

  def success?
    !self.error?
  end

  def error_messages
    error_response.nil? ? [] : error_response.collect { |e| e['errorMessage'] } 
  end

  def raw_data
    @response
  end

  def data
    {
      dep_transaction_id: @response['deviceEnrollmentTransactionId'],
      status_message: @response['enrollDevicesResponse']['statusMessage']
    } if self.success?
  end

  private

    def error_response
      resp =  @response['enrollDeviceErrorResponse'] || ship_to_error_response
      (resp.kind_of?(Array) ? resp : [resp]) if resp
    end

    def ship_to_error_response
      @response unless @response['errorMessage'].nil?
    end
end
