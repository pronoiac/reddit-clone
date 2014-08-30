class PostsController < ApplicationController
  
  before_action :require_user, except: :show
  # before_action :edit_privileges?, only: [ :edit, :update ]
  
  def new
    @post = Post.new
    render :new
  end
  
  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      flash[:notices] = ["Post successfully made"]
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    render :show
  end
  
  def edit
    @post = Post.find(params[:id])
    if edit_privileges?(@post)
      render :edit
    else
      # error message in flash.
      flash[:errors] = ["You're not authorized to edit this post."]
      # redirect. 
      redirect_to post_url(@post)
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if edit_privileges?(@post)
      if @post.update_attributes(post_params)
        flash[:notices] = ["Post successfully edited!"]
        redirect_to post_url(@post)
      else
        flash[:errors] = @post.errors.full_messages
        render :edit
      end
    else
      flash[:errors] = ["You're not authorized to edit this post."]
      redirect_to post_url(@post)
    end
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
  
  def edit_privileges?(post)
    current_user.id == post.author_id
  end
  
end
