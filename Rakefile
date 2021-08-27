# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.requires << "rubocop-rails"
end

task default: %i[rubocop]

task setup_log: :environment do
  File.new "/tmp/articles.txt", File::CREAT, 0o644 unless File.exist? "/tmp/articles.txt"
  File.write("/tmp/articles.txt", "\nLog of #{Time.current}\n", mode: "a")
end

task articles: ["setup_log", :environment] do
  articles = Article.all.to_ary
  articles.each do |article|
    File.write("/tmp/articles.txt", article.to_s << "\n", mode: "a")
  end
end
