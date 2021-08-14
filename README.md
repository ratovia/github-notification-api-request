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
