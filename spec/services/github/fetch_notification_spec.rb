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
