require 'octokit'

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts "ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?"
    exit()
end

module PullRequest
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    @client.auto_paginate = true
    
    def self.get_open_prs_by_repo_name(repo_owner, repo_name)
        new_prs = []

        begin
            puts "Fetching open pull requests for repository: #{repo_name}"
            pull_requests = @client.pull_requests("#{repo_owner}/#{repo_name}", state: 'open')
            pull_requests.each do |pr|
                puts "##{pr[:number]} | #{pr[:title]} | #{pr[:user][:login]} | #{pr[:html_url]}"
            end
        rescue Octokit::Error => error
            if error.response_body
                puts "Error fetching repositories! Message: #{error.response_body}"
            end
        end
    end
end