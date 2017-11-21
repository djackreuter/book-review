class BooksController < ApplicationController

# define before action to run before any other methods are used
    before_action :find_book, only: [:show, :edit, :update, :destroy]

# get all books in model and order by created at
    def index
        @books = Book.all.order("created_at DESC")
    end

    def show
    end

# define create and new methods for creating new book 
    def new
        @book = Book.new
    end

    def create
        @book = Book.new(book_params)
        if @book.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    # define information user will fill out
    private 
        def book_params
            params.require(:book).permit(:title, :description, :author)
        end

        # corrasponds to the id of the book that is clicked on
        def find_book
            @book = Book.find(params[:id])
        end
end
