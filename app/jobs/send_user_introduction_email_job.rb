# app/jobs/send_user_introduction_email_job.rb
class SendUserIntroductionEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Send the actual email
    user.send_introduction_email!

    # Broadcast the updated component using the component's own method
    UserCard.new(user: user, sending_email: false).broadcast_refresh!
  end
end
