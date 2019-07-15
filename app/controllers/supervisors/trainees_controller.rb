class Supervisors::TraineesController < ApplicationController

  before_action :load_users, only: %i(edit update)
  before_action :load_course, only: %i(edit update)

  def show; end

  def edit; end

  def update
    if @course.update_attributes course_user_params
      redirect_to supervisors_courses_path
    else
      render :edit
    end
  end

  private

  def course_user_params
    params.require(:course).permit :id, course_users_attributes:
      [:id, :course_id, :user_id, :_destroy]
  end

  def load_users
    @users = User.trainees.newest
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course
    flash[:warning] = t "messages.course_not_found"
    redirect_to supervisors_courses_path
  end

end
