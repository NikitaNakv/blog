class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token
  around_action :log_req_info, only: [:show]
  after_action :inc_view, only: [:show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.markup("<h1>#{@article.title}</h1>\n<p>#{@article.body}</p>\n<p>views: #{@article.views}</p>")
        # Use whatever prawn methods you need on the pdf object to generate the PDF file right here.
  
        send_data pdf.render, type: "application/pdf", disposition: "inline"
        # send_data renders the pdf on the client side rather than saving it on the server filesystem.
        # Inline disposition renders it in the browser rather than making it a file download.
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
    else
      render :new
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

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end

    def inc_view
      @article = Article.find(params[:id])
      @article.views += 1
      @article.save  
    end

    def log_req_info 
      logger = Logger.new(STDOUT) 
      logger.info("IP: #{request.ip}")
      logger.info("Content-Type: #{request.headers["Content-Type"]}")
      logger.info("User-Agent: #{request.headers["User-Agent"]}")

      logger.info("STATUS: #{response.status} #{response.message}")

      yield
    end
end
