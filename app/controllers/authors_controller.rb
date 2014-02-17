class AuthorsController < ApplicationController
  before_action :set_author, only: [:show]
  load_and_authorize_resource
 
  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
  end
 
  # GET /authors/1
  # GET /authors/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end
end

