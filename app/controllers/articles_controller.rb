class ArticlesController < ApplicationController
  def index
    articles = Article.order(pub_date: :desc)
    paginate json: articles, only: [:id, :title, :url, :pub_date], methods: [:category, :channel]
  end
end
