namespace :complex_scripts do
  desc "Syncronize extra files for Complex Scripts plugin."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/complex_scripts/db/migrate db"
    system "rsync -ruv --exclude '.*' vendor/plugins/complex_scripts/public ."
  end
end