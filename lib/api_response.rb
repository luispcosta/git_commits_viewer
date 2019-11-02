class ApiResponse
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