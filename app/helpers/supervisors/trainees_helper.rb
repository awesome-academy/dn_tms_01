module Supervisors::TraineesHelper
  def display_gender gender
    if gender.male?
      "fa-male"
    elsif gender.female?
      "fa-female"
    else
      "fa-male"
    end
  end

  def exists_in_course? course_id, user_id
    check = CourseUser.by_course_user(course_id, user_id).size
    check.positive?
  end
end
