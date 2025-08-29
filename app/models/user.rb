class User < ApplicationRecord
  belongs_to :account, optional: true

  def send_introduction_email_later!
    SendUserIntroductionEmailJob.perform_later(self)
  end

  def send_introduction_email!
    # Simulate email sending
    sleep(1) # Simulate API call
    update!(introduction_email_sent_at: Time.current)
  end
end
