require 'octokit'
require 'date'

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts "ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?"
    exit()
end

# other ideas:
# find all of the files changed for a pull request (and show changes?)
# see https://docs.github.com/en/rest/guides/scripting-with-the-rest-api-and-ruby?apiVersion=2022-11-28

# see if anybody made a pull request in a repo that i am in
# see if anybody commented on a pull request in ^
# make a new repo?
module ListRepos
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    # github only fetches 30 at a time
    @client.auto_paginate = true

    def self.display_specific_inactive_repos
        puts self.fetch_inactive_repos(true)
    end

    def self.display_inactive_repos()
        puts self.fetch_inactive_repos(false)
    end

    def self.display_all_repos
        puts self.fetch_repos()
    end

    def self.display_all_private_repos
        puts self.fetch_repos(true)
    end

    def self.fetch_repos(private = nil)
        # nil means fetch for currently authenticated user

        repos = @client.repositories(nil, type: 'all')
        if private.nil?
            return repos.map do |repo|
                {
                    full_name: repo.full_name || 'Unknown',
                    url: repo.html_url || 'No URL',
                    private: repo.private,
                    owner: repo.owner.login || 'Unknown'
                }
            end
        elsif private
            return repos.select{ |repo| repo.private }.map do |repo|
                {
                    full_name: repo.full_name || 'Unknown',
                    url: repo.html_url || 'No URL',
                    owner: repo.owner.login || 'Unknown'
                }
            end
        end
    end

    # displays inactive repos (>= 365 days without updates)
    # if "specific" flag set to true it only checks target_repos
    def self.fetch_inactive_repos(specific)
        target_repos = {
            '1904-text-searcher' => true,
            'fred-plumbing-heating' => true,
            'extract-info-from-wikipedia' => true,
            'air-quality-app-react-frontend-only' => true,
            'retrieve-stock-market-data' => true,
            'algorithms' => true
        }
        puts "+++ CONNECTING TO THE GITHUB API +++"

        # nil means fetch for currently authenticated user
        repos = @client.repositories(nil, type: 'all')
        filtered_repos = repos.each_with_object([]) do |repo, result|
            # skip if pushed to less than 1 year ago
            next unless repo.pushed_at && repo.pushed_at <= Time.now.utc - (365 * 24 * 60 * 60)

            # if "specific" skip everything that is not in target_repos hash
            if specific
                next unless target_repos[repo.name]
            end

            result << {
                name: repo.full_name,
                url: repo.html_url,
                last_update: repo.pushed_at
            }
        end
        puts "+++ API CONNECTION SEVERED +++"
        filtered_repos
    end
end