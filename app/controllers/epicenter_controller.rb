class EpicenterController < ApplicationController

	before_action :authenticate_user!
  include TweetsHelper
  include EpicenterHelper
	
  def feed
    @tweet = Tweet.new
    @following_tweets = []

    Tweet.order(created_at: :desc).each do |tweet|
      if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id
        @following_tweets.push(tweet)
      end
    end

	end

  def show_user
    @tweet = Tweet.new
  	@user = User.find(params[:id])
    @followers = number_of_followers(@user)
  end

  def all_users
    @users = User.order(:username)
  end

  def following
    @user = User.find(params[:id])
    @users = []

    User.all.each do |user|
      if @user.following.include?(user.id)
        @users.push(user)
      end
    end

  end

  def followers
    @user =  User.find(params[:id])
    @users = []

    User.all.each do |user|
      if user.following.include?(@user.id)
        @users.push(user)
      end
    end
    
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

    @tweet = get_tagged(@tweet)
    @tweet.save
    
    redirect_to root_path
  end

  def tag_tweets
    @tag = Tag.find(params[:id])
  end

  def trending
    # Hash of top 3 tweeters
    @tweet_hash = Tweet.group(:user_id).order('count_id desc').limit(3).count(:id)
    # Hash of top 3 tags
    @tweet_tag_hash = TweetTag.group(:tag_id).order('count_id desc').limit(3).count(:id)
  end

end
