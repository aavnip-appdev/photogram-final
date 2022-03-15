class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_id = params.fetch("query_recipient_id")
    recipient = User.where({ :id => the_id })
    @the_recipient = recipient.at(0)
    @the_recipient_followers = @the_recipient.followers

    if @the_recipient.private == true

      the_follow_request = FollowRequest.new
      the_follow_request.sender_id = @current_user.id
      the_follow_request.recipient_id = @the_recipient.id
      the_follow_request.status = "pending"

        if the_follow_request.valid?
          the_follow_request.save
          redirect_to("/follow_requests", { :notice => "Follow request sent." })
        else
          redirect_to("/follow_requests", { :notice => "Error. Follow request failed to create successfully." })
        end
    else
      the_follow_request = FollowRequest.new
      the_follow_request.sender_id = @current_user.id
      the_follow_request.recipient_id = @the_recipient.id
      the_follow_request.status = "accepted"

        if the_follow_request.valid?
          the_follow_request.save
          redirect_to("/users/#{@the_recipient.username}", { :notice => "Follow request created successfully." })
        else
          redirect_to("/follow_requests", { :notice => "Error. Follow request failed to create successfully." })
        end
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => "Follow request failed to update successfully." })
    end
  end

  def accept_follow_request
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({:sender_id => the_id }).where({:recipient_id => @current_user.id}).at(0)

    the_follow_request.sender_id = the_id
    the_follow_request.recipient_id = @current_user.id
    the_follow_request.status = "accepted"

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{@current_user.username}", { :notice => "Accepted follow request."})
    else
      redirect_to("/users/#{@current_user.username}", { :alert => "Follow request failed to update successfully." })
    end
  end

  def reject_follow_request
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({:sender_id => the_id }).where({:recipient_id => @current_user.id}).at(0)

    the_follow_request.sender_id = the_id
    the_follow_request.recipient_id = @current_user.id
    the_follow_request.status = "rejected"

    redirect_to("/users/#{@current_user.username}", { :alert => "Rejected follow request." })
    
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :recipient_id => the_id }).where({:sender_id => @current_user.id}).at(0)

    the_follow_request.destroy

    redirect_to("/follow_requests", { :notice => "Follow request deleted successfully."} )
  end
end
