
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    attrs = params[:user].presence || random_user_attributes
    @user = User.new(attrs)

    respond_to do |format|
      if @user.save
        Turbo::StreamsChannel.broadcast_append_to(
          "users",
          target: "users_list",
          renderable: UserCard.new(user: @user),
          layout: false
        )
        format.turbo_stream
        format.html { redirect_to users_path, notice: "User created!" }
        format.json { render json: @user, status: :created }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("users_list", partial: "users/form", locals: { user: @user }) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def random_user_attributes
    {
      name: [
        ["Alice", "Bob", "Charlie", "Dana", "Eve"].sample,
        ["Smith", "Johnson", "Lee", "Brown", "Garcia"].sample
      ].join(" "),
      email: "demo#{SecureRandom.hex(4)}@example.com"
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
