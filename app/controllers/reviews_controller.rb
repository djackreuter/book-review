class ReviewsController < ApplicationController
    # make @book accessable 
    before_action :find_book
    before_action :find_review, only: [:edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :edit]

    def new
        @review = Review.new
    end

    def create
        @review = Review.new(review_params)

        # associate review with current book and current user
        @review.book_id = @book.id
        @review.user_id = current_user.id

        if @review.save
            redirect_to book_path(@book)
        else
            render 'new'
        end
    end

    def edit
        # dont need this line here anymore because the method was defined and called by before_action
        # @review = Review.find(params[:id])
    end

    def update
        @review = Review.find(params[:id])

        if @review.update(review_params)
            redirect_to book_path(@book)
        else
            render 'edit'
        end
    end

    def destroy
        @review.destroy
        redirect_to book_path(@book)
    end

    private 
        # require the name which is review, and pass through what will be permitted 
        def review_params
            params.require(:review).permit(:rating, :comment)
        end

        def find_book
            # finds current book view is associated with based on book_id
            @book = Book.find(params[:book_id])
        end

        def find_review
            @review = Review.find(params[:id])
        end            
end
