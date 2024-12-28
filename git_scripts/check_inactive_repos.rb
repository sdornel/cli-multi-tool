

require 'octokit'
require 'date'
require 'dotenv'

Dotenv.load

GITHUB_TOKEN = ENV['GITHUB_TOKEN']
GITHUB_USERNAME = ENV['GITHUB_USERNAME']

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts "ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?"
    exit()
end

# other ideas:
# find all of the files changed for a pull request (and show changes?)
# see https://docs.github.com/en/rest/guides/scripting-with-the-rest-api-and-ruby?apiVersion=2022-11-28

# see if anybody made a pull request in a repo that i am in
# see if anybody commented on a pull requeust in ^
# list all of my repos by name and url
# make a new repo?
module CheckInactiveRepos
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)

    def self.display_specific_inactive_repos
        puts self.fetch_specific_inactive_repos
    end

    # displays inactive repos (>= 365 days without updates from specific list)
    def self.fetch_specific_inactive_repos()
        target_repos = {
            '1904-text-searcher' => true,
            'fred-plumbing-heating' => true,
            'extract-info-from-wikipedia' => true,
            'air-quality-app-react-frontend-only' => true,
            'retrieve-stock-market-data' => true,
            'algorithms' => true
        }
        puts "+++ CONNECTING TO THE GITHUB API +++"

        # github only fetches 30 at a time
        @client.auto_paginate = true
        # nil means fetch for currently authenticated user
        repos = @client.repositories(nil, type: 'all')
        filtered_repos = repos.each_with_object([]) do |repo, result|
            # check if repo is included in hashmap and see if it was last updated at least 1 year ago
            if target_repos[repo.name] && repo.pushed_at && repo.pushed_at <= Time.now.utc - (365 * 24 * 60 * 60)
                result << {
                    name: repo.full_name,
                    url: repo.html_url,
                    last_update: repo.pushed_at
                }
            end
        end

        return filtered_repos
    end
end