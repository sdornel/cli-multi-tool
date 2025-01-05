require 'octokit'
require 'date'
require_relative '../helpers/colorable_string/colorable_string'
using ColorableString

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts 'ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?'.fg_color(:red)
    exit()
end

# other ideas:
# find all of the files changed for a pull request (and show changes?)
# see https://docs.github.com/en/rest/guides/scripting-with-the-rest-api-and-ruby?apiVersion=2022-11-28

# see if anybody made a pull request in a repo that i am in
# see if anybody commented on a pull request in ^
# make a new repo?
module ListRepos
    extend self
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    # github only fetches 30 at a time
    @client.auto_paginate = true

    def display_specific_inactive_repos
        puts fetch_inactive_repos(true)
    end

    def display_inactive_repos()
        puts fetch_inactive_repos(false)
    end

    def display_all_repos
        puts fetch_repos()
    end

    def display_all_private_repos
        puts fetch_repos(true)
    end

    def fetch_repos(private = nil)
        # nil means fetch for currently authenticated user

        repos = @client.repositories(nil, type: 'all')
        if private.nil?
            return repos.map do |repo|
                format_repo_info(repo, private)
            end
        elsif private
            repos.select{ |repo| repo.private }.map do |repo|
                format_repo_info(repo, private)
            end
        end
    end

    # displays inactive repos (>= 365 days without updates)
    # if "specific" flag set to true it only checks target_repos
    def fetch_inactive_repos(specific)
        target_repos = {
            '1904-text-searcher' => true,
            'fred-plumbing-heating' => true,
            'extract-info-from-wikipedia' => true,
            'air-quality-app-react-frontend-only' => true,
            'retrieve-stock-market-data' => true,
            'algorithms' => true
        }.freeze

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
        filtered_repos
    end

    def format_repo_info(repo, private)
        separator = '-' * 40
        <<~INFO
          #{separator}
          #{'Repository:'.fg_color(:yellow)} #{repo.full_name.fg_color(:green)}
          #{'URL:'.fg_color(:yellow)} #{repo.html_url.fg_color(:cyan)}
          #{'Owner:'.fg_color(:yellow)} #{repo.owner.login.fg_color(:green)}
          #{"#{'Private:'.fg_color(:yellow)} #{repo.private ? 'Yes'.fg_color(:red) : 'No'.fg_color(:green)}" unless private}
        INFO
    end
end
