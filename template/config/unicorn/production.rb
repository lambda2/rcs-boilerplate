
root = "/home/deployer/apps/%NAME/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end

stderr_path "/home/deployer/apps/%NAME/unicorn_err.log"
stdout_path "/home/deployer/apps/%NAME/unicorn.log"

worker_processes 2
timeout 60
# preload_app true

listen '/tmp/unicorn.%NAME.sock', backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
