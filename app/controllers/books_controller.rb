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
# Builds out books from current user
# replaced Book.new
    def new
        @book = current_user.books.build
    end

    def create
        @book = current_user.books.build(book_params) 
        if @book.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    # dont need to use @book because it's already referenced in before_action 
    def edit
    end

    def update 
        if @book.update(book_params)
            redirect_to book_path(@book)
        else
            render 'edit'
        end
    end

    def destroy 
        @book.destroy
        redirect_to root_path
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
