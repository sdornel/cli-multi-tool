require 'octokit'
using ColorableString
if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts 'ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?'.fg_color(:red)
    exit()
end

module PullRequest
    def list_outdated_dependencies

    end
end