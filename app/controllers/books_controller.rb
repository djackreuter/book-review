class BooksController < ApplicationController

# define before action to run before any other methods are used
    before_action :find_book, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :edit]

# get all books in model and order by created at
    def index
        # if catagory params are blank, show all books
        if params[:category].blank?
            @books = Book.all.order("created_at DESC")
        else
            # get id of category selected from category dropdown
            @category_id = Category.find_by(name: params[:category]).id
            @books = Book.where(:category_id => @category_id).order("created_at DESC")
        end
    end

    def show
        if @book.reviews.blank?
            @average_review = 0
        else
            @average_review = @book.reviews.average(:rating).round(2)
        end
    end

# define create and new methods for creating new book 
# Builds out books from current user
# replaced Book.new
# @categories adds a way to access categories when user creates a new book
    def new
        @book = current_user.books.build
        @categories = Category.all.map{ |c| [c.name, c.id] }
    end

    def create
        @book = current_user.books.build(book_params) 
        @book.category_id = params[:category_id]
        if @book.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    # dont need to use @book because it's already referenced in before_action 
    # allow edit method access to the categories
    def edit
        @categories = Category.all.map{ |c| [c.name, c.id] }        
    end

    def update 
        @book.category_id = params[:category_id]        
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
            params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
        end

        # corrasponds to the id of the book that is clicked on
        def find_book
            @book = Book.find(params[:id])
        end
end
