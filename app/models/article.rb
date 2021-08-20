class Article < ApplicationRecord
  after_initialize :default_values

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :views, presence: true

  def to_s
    s = "Title: #{self.title},\nBody: #{self.body},\nViews: #{self.views}"    
  end

  private
    def default_values
      self.views ||= 0
    end

end
