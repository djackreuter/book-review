class BooksController < ApplicationController
    def index
    end

# define create and new methods for creating new book 
    def new
        @book = Book.new
    end

    def create
        @book = Book.new(book_params)
    end

    # define information user will fill out
    private 
        def book_params
            params.require(:book).permit(:title, :description, :author)
        end
end
