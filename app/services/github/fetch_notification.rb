module Github
  class FetchNotification < Github::Base
    def call(user, repo)
      response = get("/repos/#{user}/#{repo}/issues/comments")
      puts response
    end
  end
end
