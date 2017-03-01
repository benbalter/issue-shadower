require 'sinatra'
require 'octokit'

class IssueShadower < Sinatra::Base
  def client
    @client ||= Octokit::Client.new({
      access_token: ENV["GITHUB_TOKEN"],
      api_endpoint: "#{ENV["GITHUB_HOST"]}/api/v3/"
    })
  end

  def payload
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def signature_valid?
    return false unless request.body && request.env['HTTP_X_HUB_SIGNATURE']
    digest = OpenSSL::Digest.new('sha1')
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(digest, ENV['GITHUB_HOOK_SECRET'], request.body.read)
    Rack::Utils.secure_compare signature, request.env['HTTP_X_HUB_SIGNATURE']
  end

  def repo
    payload["repository"]["fullname"]
  end

  def issue
    client.issue repo, payload["issue"]["number"]
  end

  post "/payload" do
    halt 409 unless signature_valid?
    halt 200 unless issue && payload["action"] == "opened"
    client.create_issue repo, issue.title, "Shaddow issue for #{issue.html_url}\n---\n" + issue.body
  end
end
