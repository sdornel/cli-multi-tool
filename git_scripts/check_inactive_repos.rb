

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