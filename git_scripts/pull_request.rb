require 'octokit'
require 'dotenv'

Dotenv.load

GITHUB_TOKEN = ENV['GITHUB_TOKEN']
GITHUB_USERNAME = ENV['GITHUB_USERNAME']

if GITHUB_TOKEN.nil? || GITHUB_TOKEN.empty?
    puts "ERROR: GITHUB_TOKEN cannot be empty! Is the token set in your .env file?"
    exit()
end

module PullRequest
    @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
    
    def get_changed_files
        files_changed = []
        @client.auto_paginate = true

    end
end