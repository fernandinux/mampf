# MainController
class MainController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about, :news,
                                                 :sponsors]
  before_action :check_for_consent

  def home
    if user_signed_in?
      cookies[:locale] = current_user.locale
    end
    render layout: 'application_no_sidebar'
  end

  def error
    redirect_to :root, alert: I18n.t('controllers.no_page')
  end

  def news
    @announcements = Announcement.where(lecture: nil).order(:created_at)
                                 .reverse
    render layout: 'application_no_sidebar'
  end

  def sponsors
    render layout: 'application_no_sidebar'
  end

  def comments
    @media_comments = current_user.media_latest_comments
    @media_comments.select! do |m|
      (Reader.find_by(user: current_user, thread: m[:thread])
            &.updated_at || (Time.now - 1000.years)) < m[:latest_comment].created_at
    end
    @media_array = Kaminari.paginate_array(@media_comments)
                           .page(params[:page]).per(10)
    render layout: 'application_no_sidebar'
  end

  private

  def check_for_consent
    return unless user_signed_in?
    redirect_to consent_profile_path unless current_user.consents
  end
end
