class Supervisors::TraineesController < Supervisors::SupervisorsController
  before_action :load_course_user, only: :destroy

  def new
    @users = User.trainees.newest
  end

  def create
    column = [:user_id, :course_id]
    ActiveRecord::Base.transaction do
      CourseUser.import column, course_user_data
      AssignTraineeJob.perform_later(list_emails,
        params["course_user"]["course_id"], 1)
      flash[:success] = t "messages.save_success"
      redirect_to request.referrer
    end
    rescue StandardError
      flash[:danger] = t "messages.save_unsuccess"
      redirect_to request.referrer
  end

  def destroy
    ActiveRecord::Base.transaction do
      check = User.select(:email).find_by id: params[:id]
      if check.present?
        if @course_user.destroy
          msg = {status: "success", message: t("messages.destroy_success")}
          AssignTraineeJob.perform_later(check.email, params[:course_id], 2)
        else
          msg = {status: "fail", message: t("messages.error")}
        end
      else
        msg = {status: "not_found", message: t("messages.not_found")}
      end
      respond_to do |format|
        format.json{render json: msg}
      end
    end
    rescue StandardError
      flash[:danger] = t "messages.destroy_error"
      redirect_to request.referrer
  end

  private

  def course_user_prams
    params.require(:course_user).permit :id, :course_id, user_ids: []
  end

  def load_course_user
    @course_user = CourseUser.find_by(user_id: params[:id], course_id:
      params[:course_id])
    return if @course_user
    respond_to do |format|
      msg = {status: "ok", message: t("messages.not_found")}
      format.json{render json: msg}
    end
  end

  def course_user_data
    @data = course_user_prams["user_ids"].map{ |user_id|
      {user_id: user_id, course_id: course_user_prams["course_id"]} }
  end

  def list_emails
    @emails = course_user_data.map { |id| User.byId(id[:user_id]).pluck(:email, :fullname)[0] }
  end
end
