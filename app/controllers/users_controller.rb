class UsersController < ApplicationController
# Uncomment this if you want to force users to sign in before any other actions
# skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

def index
  matching_users = User.all

  @list_of_users = matching_users.order({ :username => :asc })

  render({ :template => "users/index.html.erb" })
end

def show
  the_username = params.fetch("the_username")

  matching_users = User.where({ :username => the_username })

  @the_user = matching_users.at(0)

  render({ :template => "users/show.html.erb" })
end

def liked_photos
  the_username = params.fetch("the_username")

  matching_users = User.where({ :username => the_username })

  @the_user = matching_users.at(0)

  if @current_user != nil
    render({ :template => "users/liked_photos.html.erb" })
  else
    redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
  end
end

def feed
  the_username = params.fetch("the_username")
  matching_users = User.where({ :username => the_username })
  @the_user = matching_users.at(0)

  @the_user_following = @the_user.sender_follow_requests_accepted

  #@the_user.sender_follow_requests_accepted.each do |a_accepted_following| 
    #@the_user_feed = User.where({:id => a_accepted_following}).at(0)
  #end

  if @current_user != nil
    render({ :template => "users/feed.html.erb" })
  else
    redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
  end
  
end

def discover
  the_username = params.fetch("the_username")

  matching_users = User.where({ :username => the_username })

  @the_user = matching_users.at(0)

  @the_user_following = @the_user.activity

  if @current_user != nil
    render({ :template => "users/discover.html.erb" })
  else
    redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
  end
end

def not_authorized
  the_username = params.fetch("the_username")
  matching_users = User.where({ :username => the_username })
  @the_user = matching_users.at(0)
  redirect_to("/", {:notice => "You are not authorized for that." })
end
 
end