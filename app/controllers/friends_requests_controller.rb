class FriendsRequestsController < ApplicationController
  before_action :current_user_must_be_friends_request_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_friends_request_user
    friends_request = FriendsRequest.find(params[:id])

    unless current_user == friends_request.sender
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @friends_requests = FriendsRequest.page(params[:page]).per(10)

    render("friends_requests/index.html.erb")
  end

  def show
    @friends_request = FriendsRequest.find(params[:id])

    render("friends_requests/show.html.erb")
  end

  def new
    @friends_request = FriendsRequest.new

    render("friends_requests/new.html.erb")
  end

  def create
    @friends_request = FriendsRequest.new

    @friends_request.sender_id = params[:sender_id]
    @friends_request.recipient_id = params[:recipient_id]

    save_status = @friends_request.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/friends_requests/new", "/create_friends_request"
        redirect_to("/friends_requests")
      else
        redirect_back(:fallback_location => "/", :notice => "Friends request created successfully.")
      end
    else
      render("friends_requests/new.html.erb")
    end
  end

  def edit
    @friends_request = FriendsRequest.find(params[:id])

    render("friends_requests/edit.html.erb")
  end

  def update
    @friends_request = FriendsRequest.find(params[:id])

    @friends_request.sender_id = params[:sender_id]
    @friends_request.recipient_id = params[:recipient_id]

    save_status = @friends_request.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/friends_requests/#{@friends_request.id}/edit", "/update_friends_request"
        redirect_to("/friends_requests/#{@friends_request.id}", :notice => "Friends request updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Friends request updated successfully.")
      end
    else
      render("friends_requests/edit.html.erb")
    end
  end

  def destroy
    @friends_request = FriendsRequest.find(params[:id])

    @friends_request.destroy

    if URI(request.referer).path == "/friends_requests/#{@friends_request.id}"
      redirect_to("/", :notice => "Friends request deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Friends request deleted.")
    end
  end
end
