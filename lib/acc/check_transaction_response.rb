class ACC::CheckTransactionResponse
  def initialize json_response
    @response = json_response
  end

  def error?
    ship_to_error? ||
    error_response.present? ||
    @response['statusCode'] == 'ERROR' ||
    @response['statusCode'] == 'COMPLETE_WITH_ERRORS'
  end

  def complete?
    self.success? && @response['statusCode'] == 'COMPLETE'
  end

  def in_progress?
    in_progress_array_error? || in_progress_error?
  end


  def in_progress_array_error?
    error_response.present? && error_response.kind_of?(Array) && error_response.first['errorCode'] == 'DEP-ERR-4003'
  end

  def in_progress_error?
    error_response.present? && error_response['errorCode'] == 'DEP-ERR-4003'
  end

  def success?
    !self.error?
  end

  def error_messages
    messages = [ship_to_error_message] + [single_error_message] + multiple_error_messages
    messages.delete_if? { |k, v| v.blank? }
  end

  def data
    @response
  end

  private
    def ship_to_error?
      @response['errorCode'].present?
    end

    def error_response
      @response['checkTransactionErrorResponse']
    end

    def ship_to_error_response
      @response['errorMessage']
    end

    def single_error_message
      error_response['errorMessage'] if error_response.present?
    end

    def multiple_error_messages
      if error_response.present? && error_response.kind_of?(Array)
        error_response.collect { |e| e['errorMessage'] }
      end
    end
end
