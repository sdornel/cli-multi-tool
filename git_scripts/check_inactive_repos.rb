require 'octokit'
require 'date'
require 'dotenv'

Dotenv.load

octokit = Octokit::Client.new(access_token: "YOUR-TOKEN")

module CheckInactiveRepos
    def self.fetch_repositories
        puts "hi2"
    end
end