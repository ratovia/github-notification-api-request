## GithubのPRコメントを取得する

### usage
`Github::FetchNotification.new.call('user','repo')`

example
```bash
$ rails c
> Github::FetchNotification.new.call('ratovia','github-notification-api-request')
LGTM
```
### 実装コード
```ruby
# app/services/github/base.rb
module Github
  class Base
    BASE_URL = 'https://api.github.com'.freeze
    API_VERSION = 'application/vnd.github.v3+json'.freeze

    def initialize
      @base_uri = BASE_URL
      @base_headers = {
        Accept: API_VERSION
      }
      @client = Faraday.new @base_uri do |f|
        f.request  :url_encoded
        f.request  :retry, max: 3, interval: 0.5
        f.response :logger, Rails.logger
        f.adapter  :net_http
      end
    end

    def get(path, params = {}, options = {})
      @client.get(path, params, options)
    end
  end
end
```

```ruby
# app/services/github/fetch_notification.rb

module Github
  class FetchNotification < Github::Base
    def call(user, repo)
      response = get("/repos/#{user}/#{repo}/issues/comments")
      if response.status == 200
        Rails.logger.debug JSON.parse(response.body).last["body"]
      else
        Rails.logger.fatal "Failed to fetch notification"
      end
    end
  end
end
```

#### webmock
```ruby
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "FetchNotification", type: :service do
  before do
    WebMock.enable!
  end

  let(:user) { 'ratovia' }
  let(:repo) { 'git-app' }

  describe "#call" do
    before do
      WebMock.stub_request(
        :get, "https://api.github.com/repos/#{user}/#{repo}/issues/comments"
      ).with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.7.0'
        }
      ).to_return(
        body: File.read("#{Rails.root}/spec/fixtures/github_notification_response.json"),
        status: 200,
      )
    end
    it 'コメントが返ってくる' do
      response = Github::FetchNotification.new.call(user, repo)
      expect(response).to eq(["スタブコメント1","スタブコメント2"])
    end
  end
end
```
