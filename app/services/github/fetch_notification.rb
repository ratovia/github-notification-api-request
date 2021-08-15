module Github
  class FetchNotification < Github::Base
    def call(user, repo)
      response = get("/repos/#{user}/#{repo}/issues/comments")
      if response.status == 200
        data = JSON.parse(response.body).map{|v| v["body"]}
        Rails.logger.debug data
        return data
      else
        Rails.logger.fatal "Failed to fetch notification"
      end
    end
  end
end
