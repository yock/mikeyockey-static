require 'mina/bundler'
require 'mina/git'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '45.55.169.74'
set :deploy_to, '/var/www/vhosts/mikeyockey.com'
set :repository, 'git@github.com:yock/mikeyockey.git'
set :branch, 'master'
set :user, 'myockey'
set :ssh_options, '-A -t'
set :shared_paths, %w(twtxt.txt)

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
    invoke :'deploy:link_shared_paths'

    to :launch do
    end
  end
end

