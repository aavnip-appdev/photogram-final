class UsersController < ApplicationController
# Uncomment this if you want to force users to sign in before any other actions
# skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

def index
  matching_users = User.all

  @list_of_users = matching_users.order({ :created_at => :desc })

  render({ :template => "users/index.html.erb" })
end

def show
  the_username = params.fetch("the_username")

  matching_users = User.where({ :username => the_username })

  @the_user = matching_users.at(0)

  render({ :template => "users/show.html.erb" })
end

end