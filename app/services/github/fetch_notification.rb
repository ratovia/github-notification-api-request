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
