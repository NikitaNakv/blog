# frozen_string_literal: true

# article controller
class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :log_req_info, only: [:show]
  around_action :switch_locale
  after_action :inc_view, only: [:show]

  #  layout "layouts/_article_list_layout", only: [:index]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render xml: @article.to_xml }
      format.pdf do
        pdf = Prawn::Document.new
        pdf.markup("<h1>#{@article.title}</h1>\n<p>#{@article.body}</p>\n<p>views: #{@article.views}</p>")
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
      flash[:notice] = t(:article_succesfuly_created)
    else
      render :new
      flash[:errors] = t(:error_on_creating_new_post)
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :locale)
  end

  def inc_view
    @article = Article.find(params[:id])
    @article.views += 1
    @article.save
  end

  def log_req_info
    logger = Logger.new($stdout)
    logger.info("IP: #{request.ip}\nContent-Type: #{request.headers["Content-Type"]}\n
            User-Agent: #{request.headers["User-Agent"]}")
    logger.info("STATUS: #{response.status} #{response.message}")
    yield
  end
end
