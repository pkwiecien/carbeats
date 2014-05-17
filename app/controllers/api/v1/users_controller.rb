class Api::V1::UsersController < ApiController
  respond_to :xml, :json

  # GET /api/v1/users/
  def index
    @users = User.all
    render json: @users
  end

  # GET /api/v1/users/:id
  def show
  end

  # POST /api/v1/users
  def create
  end

  # PUT /api/v1/users/:id
  def update
  end

  private


end