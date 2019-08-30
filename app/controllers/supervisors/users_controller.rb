class Supervisors::UsersController < Supervisors::SupervisorsController
  before_action :load_user, only: %i(edit update destroy)
  before_action :is_supervisor?

  def index
    @users = User.newest.paginate page: params[:page],
      per_page: Settings.per_page_default
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "messages.save_success"
      redirect_to supervisors_users_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "messages.update_success"
      redirect_to supervisors_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      render json: {msg: t("messages.destroy_success"), cls: "success"}
    else
      render json: {msg: t("messages.destroy_error"), cls: "danger"}
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :password_confirmation,
      :role, :fullname, :birthday, :gender, :avatar
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "user.message.user_not_default"
    redirect_to supervisors_root_path unless @user
  end
end
