class Acc::CheckTransactionResponse
  def initialize json_response
    @response = json_response
  end

  def error?
    !error_response.nil? || ship_to_error? || order_error?
  end

  def order_error?
    @response['statusCode'] == 'ERROR' || @response['statusCode'] == 'COMPLETE_WITH_ERRORS'
  end

  def complete?
    self.success? && @response['statusCode'] == 'COMPLETE'
  end

  def in_progress?
    error_response.kind_of?(Array) ? in_progress_array_error? : in_progress_error?
  end


  def in_progress_array_error?
    !error_response.nil? && error_response.first['errorCode'] == 'DEP-ERR-4003'
  end

  def in_progress_error?
    !error_response.nil? && error_response['errorCode'] == 'DEP-ERR-4003'
  end

  def success?
    !self.error?
  end

  def error_messages
    messages = [ship_to_error_message] + [single_error_message] + multiple_error_messages
    messages.delete_if { |msg| msg.nil? }
  end

  def data
    @response
  end

  private
    def ship_to_error?
      !@response['errorCode'].nil?
    end

    def error_response
      @response['checkTransactionErrorResponse']
    end

    def ship_to_error_message
      @response['errorMessage']
    end

    def single_error_message
      error_response['errorMessage'] unless error_response.nil? || error_response.kind_of?(Array)
    end

    def multiple_error_messages
      if !error_response.nil? && error_response.kind_of?(Array)
        error_response.collect { |e| e['errorMessage'] }
      else
        []
      end
    end
end
