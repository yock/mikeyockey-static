require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '107.170.74.111'
set :deploy_to, '/usr/share/nginx/sites/mikeyockey.com'
set :repository, 'git@github.com:yock/mikeyockey.git'
set :branch, 'master'
set :user, 'myockey'
set :ssh_options, '-A'

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-2.1.0@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
end

task :deps do
  queue "bundle install"
  queue "npm install"
  queue "bower install"
end

task :compile do
  queue "grunt build"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :deps
    invoke :compile

    to :launch do
      queue "sudo /home/myockey/util/restart-nginx.sh"
    end
  end
end

