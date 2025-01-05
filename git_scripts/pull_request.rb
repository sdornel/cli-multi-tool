require 'octokit'
using ColorableString
if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts 'ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?'.fg_color(:red)
    exit()
end

module PullRequest
    extend self
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    @client.auto_paginate = true
    
    def get_open_prs_by_repo_name(repo_owner, repo_name)
        new_prs = []

        begin
            puts "\nFetching open pull requests for repository: #{repo_owner}/#{repo_name}"
            pull_requests = @client.pull_requests("#{repo_owner}/#{repo_name}", state: 'open')

            if pull_requests.empty?
                puts 'No open pull requests found.'
                return
            end
            pull_requests.each do |pr|
                puts <<~INFO
                    #{"##{pr[:number]}".fg_color(:cyan)} | \
                    #{"#{pr[:title]}".fg_color(:green)} | \
                    #{"#{pr[:user][:login]}".fg_color(:yellow)} | \
                    #{"#{pr[:html_url]}".fg_color(:purple)}
                INFO
            end

        rescue Octokit::Error => error
            if error.response_body
                puts "Error fetching pull requests! Message: #{error.response_body}".fg_color(:red)
            end
        end
    end
end