class Supervisors::TasksController < Supervisors::SupervisorsController
  before_action :load_task, only: :destroy

  def destroy
    if @task.destroy
      render json: {msg: t("message.delete")}
    else
      render json: {msg: t("message.delete_f")}
    end
  end

  private

  def load_task
    @task = Task.find_by id: params[:id]
    return if @task
    render json: {msg: t("message.notFound")}
  end
end
