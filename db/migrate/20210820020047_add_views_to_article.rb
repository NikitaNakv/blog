class AddViewsToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :views, :integer
  end
end
