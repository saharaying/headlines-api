class ArticlesController < ApplicationController
  def index
    articles = Article.order(pub_date: :desc)
    paginate json: articles, only: [:id, :title, :url, :pub_date, :hero_image], methods: [:category, :channel], per_page: 20
  end

  def show
    article = Article.find params[:id]
    render json: article, methods: [:category, :channel]
  end
end
