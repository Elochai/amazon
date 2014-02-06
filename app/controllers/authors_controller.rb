class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy, :filter]
 
  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
  end
 
  # GET /authors/1
  # GET /authors/1.json
  def show
  end
 
  # GET /authors/new
  def new
    if current_customer.admin == true
      @author = Author.new
    end
  end
 
  # GET /authors/1/edit
  def edit
    if current_customer.admin == true
    end
  end
 
  # POST /authors
  # POST /authors.json
  def create
    if current_customer.admin == true
      @author = Author.new(author_params)
   
      respond_to do |format|
        if @author.save
          format.html { redirect_to @author, notice: 'Author was successfully created.' }
          format.json { render action: 'show', status: :created, location: @author }
        else
          format.html { render action: 'new'}
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    if current_customer.admin == true
      respond_to do |format|
        if @author.update(author_params)
          format.html { redirect_to @author, notice: 'Author was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    if current_customer.admin == true
      @author.destroy
      respond_to do |format|
        format.html { redirect_to authors_url, notice: 'Author was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  def filter
    @books = Book.where(author_id: @author.id).all
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:firstname, :lastname, :biography, :photo)
    end
end

