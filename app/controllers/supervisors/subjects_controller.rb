class Supervisors::SubjectsController < Supervisors::SupervisorsController
  before_action :load_subject, except: [:index, :create, :new]

  def index
    @subjects = Subject.includes(:tasks).paginate(per_page:
      Settings.per_page_default, page: params[:page])
  end

  def new
    @subject = Subject.new
    @subject.tasks.build
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "messages.save_success"
      redirect_to supervisors_subjects_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "messages.save_success"
      redirect_to supervisors_subjects_path
    else
      render :edit
    end
  end

  def destroy
    flash[:warning] = if @subject.destroy
      t "messages.destroy_success"
    else
      t "messages.destroy_error"
    end
    redirect_to supervisors_subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit :id, :name, :description, :picture,
      tasks_attributes: [:id, :name, :subject_id]
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject
    flash[:warning] = t "messages.not_found"
    redirect_to supervisors_subjects_path
  end
end
