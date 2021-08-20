# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :setup_log do
  sh "touch /tmp/articles.txt"
end

task articles: ["setup_log", :environment] do
  articles = Article.all.to_ary
  log = File.open("/tmp/articles.txt", "w")
  articles.each do |article|
    File.write("/tmp/articles.txt", article.to_s + "\n", mode: "a")
  end
end

