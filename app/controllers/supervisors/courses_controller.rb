class Supervisors::CoursesController < Supervisors::SupervisorsController
  before_action :load_course, only: %i(edit update destroy)
  before_action :load_subjects, except: %i(index destroy show)

  def index
    @courses = Course.newest.paginate page: params[:page],
      per_page: Settings.per_page_default
  end

  def new
    @course = Course.new
    @course.course_subjects.build
  end

  def create
    @course = Course.new course_params
    if @course.save
      add_supervisor_into_course_just_created @course
      flash[:success] = t "messages.save_success"
      redirect_to supervisors_courses_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "messages.update_success"
      redirect_to supervisors_courses_path
    else
      render :edit
    end
  end

  def destroy
    if @course.destroy
      render json: {msg: t("messages.destroy_success"), cls: "success"}
    else
      render json: {msg: t("messages.destroy_error"), cls: "danger"}
    end
  end

  private

  def course_params
    params.require(:course).permit :name, :description, :duration,
      :duration_type, :picture, :status, :date_start, :date_end,
      course_subjects_attributes: [:id, :course_id, :subject_id,
        :status, :_destroy]
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course
    flash[:warning] = t "messages.course_not_found"
    redirect_to supervisors_courses_path
  end

  def load_subjects
    @subjects = Subject.newest
  end

  def add_supervisor_into_course_just_created course
    current_user.course_users.create(course_id: course.id)
    date = count_date_send(course.date_start, course.date_end)
    SendInfoCourseToSupJob.set(wait: date.days).perform_later(course)
  end

  def count_date_send date_start, date_end
    result = date_end.to_date - date_start.to_date
    return result.to_s.split("/")[0].to_i - 2
  end
end
