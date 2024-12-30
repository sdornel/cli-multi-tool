require 'octokit'

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts "ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?"
    exit()
end

module PullRequest
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    @client.auto_paginate = true
    
    # TODO: add flag that checks for newer PRs
    def self.get_open_prs()
        new_prs = []

        begin
            repos = @client.repositories(nil, type: 'all')
            puts "Checking #{repos.size} repositories for new pull requests..."
            
            repos.map do |repo|
                begin
                    pull_requests = @client.pull_requests("#{repo.owner.login}/#{repo.name}", state: "open")
                    if pull_requests.any?
                        pull_requests.each do |pr|
                            # Filter out Dependabot PRs
                            next if pr.user.login == 'dependabot[bot]'

                            new_prs << {
                                repo: "#{repo[:owner][:login]}/#{repo[:name]}",
                                pr_number: pr.number,
                                title: pr.title,
                                user: pr.user.login,
                                url: pr.html_url
                            }
                        end
                    end
                end
            end

            puts new_prs
        rescue Octokit::Error => error
            if error.response
                puts "Error fetching repositories! Status: #{error.response.status}. Message: #{error.response.data.message}"
            end
        end
    end

    def self.get_open_prs_by_org

    end
end