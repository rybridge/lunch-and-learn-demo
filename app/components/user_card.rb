class UserCard < ApplicationComponent
  def initialize(user:, sending_email: false)
    @user = user
    @sending_email = sending_email
  end

  def id
    dom_id(@user, :user_card)
  end

  def broadcast_channel
    [@user, :user_card_refresh]
  end

  def broadcast_refresh!
    Turbo::StreamsChannel.broadcast_replace_to(
      broadcast_channel,
      target: id,
      renderable: self,
      layout: false
    )
  end

  def turbo_stream_tag
    return unless sending_email?
    helpers.turbo_stream_from(broadcast_channel)
  end

  def status_badge
    return unless introduction_email_sent?
    '<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">✓ Introduction email sent</span>'.html_safe
  end

  def send_button
    return if sending_email? || introduction_email_sent?
    helpers.button_to(
      "Send introduction email",
      helpers.user_introduction_emails_path(@user),
      method: :post,
      class: "w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded transition-colors",
      form: { data: { turbo_stream: true } }
    )
  end

  def sending_email_spinner
    return unless sending_email?
    <<-HTML.html_safe
      <div class="flex items-center text-blue-600">
        <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Sending introduction email...
      </div>
    HTML
  end

  def sending_email?
    @sending_email
  end

  def introduction_email_sent?
    @user.introduction_email_sent_at.present?
  end

  private

  attr_reader :user
end
