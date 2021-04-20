# frozen_string_literal: true

module LinksHelper
  def get_gist_files(url)
    client = Octokit::Client.new(access_token: Rails.application.credentials[:github_access_token])
    id = url.split('/').last
    returned_gist = client.gist(id)
    returned_gist[:files]
  end
end
