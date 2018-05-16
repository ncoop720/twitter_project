class EpicenterController < ApplicationController

	before_action :authenticate_user!
	
  def feed
    @tweet = Tweet.new
    @following_tweets = []

    Tweet.all.each do |tweet|
      if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id
        @following_tweets.push(tweet)
      end
    end
	end

  def show_user
    @tweet = Tweet.new
  	@user = User.find(params[:id])
  end

  def now_following
  	current_user.following.push(params[:id].to_i)
	  current_user.save

	  redirect_to show_user_path(id: params[:id])
  end

  def unfollow
    current_user.following.delete(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end

  def epi_tweet
    @tweet = Tweet.create(message: params[:tweet][:message], user_id: params[:tweet][:user_id])
    
    redirect_to root_path
  end


end