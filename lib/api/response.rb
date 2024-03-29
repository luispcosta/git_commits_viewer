# frozen_string_literal:true

module API
  # Class to build API json responses
  class Response
    def self.ok(payload)
      {
        success: true,
        result: payload
      }.to_json
    end

    def self.error(error)
      {
        success: false,
        error_message: error
      }.to_json
    end
  end
end
