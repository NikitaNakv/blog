# frozen_string_literal: true

# article entity
class Article < ApplicationRecord
  after_initialize :default_values

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :views, presence: true

  def to_s
    "Title: #{title},\nBody: #{body},\nViews: #{views}"
  end

  private

  def default_values
    self.views ||= 0
  end
end
