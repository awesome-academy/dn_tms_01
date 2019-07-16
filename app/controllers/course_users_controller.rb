class CourseUsersController < ApplicationController
  before_action :logged_in_user, :is_trainee?
  before_action :load_course, only: :show

  def show; end

  private

  def load_course
    @course_user = CourseUser.includes(:course, :subjects).find_by(id:
      params[:id], user_id: current_user.id)
    return render html: t("not_found") unless @course_user
  end
end
