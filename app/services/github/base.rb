module Github
  class Base
    BASE_URL = 'https://api.github.com'
    API_VERSION = 'application/vnd.github.v3+json'
    attr_accessor :token, :base_uri

    def initialize()
      @token = token
      @base_uri = BASE_URL
      @base_headers = {
        Accept: "#{API_VERSION}"
      }
      @client = Faraday.new @base_uri do |f|
        f.basic_auth(
          Rails.application.credentials.github[:client_id],
          Rails.application.credentials.github[:secret_id]
        )
      end
    end

    def get(path, params = {}, options = {})
      @client.get(path, params, options)
    end

    # def post(path, options = {})
    #   options[:headers] = { 'Authorization' => "token #{@token}" }
    #   self.class.post(path, options)
    # end

    # def put(path, options = {})
    #   options[:headers] = { 'Authorization' => "token #{@token}" }
    #   self.class.put(path, options)
    # end

    # def delete(path, options = {})
    #   options[:headers] = { 'Authorization' => "token #{@token}" }
    #   self.class.delete(path, options)
    # end
  end
end
