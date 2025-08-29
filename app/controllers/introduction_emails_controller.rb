class IntroductionEmailsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @user.send_introduction_email_later!

    # Immediately respond with loading state
    user_card = UserCard.new(user: @user, sending_email: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(user_card.id, user_card)
      end
    end
  end
end
