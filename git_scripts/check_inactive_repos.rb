

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
    def self.fetch_repositories
        puts "CONNECTING TO GITHUB API"
        all_repos = []
        # begin
        puts @client.user
        puts "+++ CONNECTING TO THE GITHUB +++"
        @client.auto_paginate = true
        repos = @client
        # binding.pry
        # rescue
        #     puts "oops"
        # end
    end
end