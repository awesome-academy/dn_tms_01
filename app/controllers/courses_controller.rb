class CoursesController < ApplicationController
  def index
    @courses = Course.sort_by_status.paginate(per_page: Settings.per_page_default,
      page: params[:page])
  end
end
