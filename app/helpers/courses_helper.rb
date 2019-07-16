module CoursesHelper
  # Display error message on input field
  def display_error field, custom_field_name = nil
    return unless @course.errors[field].present?
    name = custom_field_name ? custom_field_name : field.to_s.titlecase
    raw "<span class=\"error_message\">  #{name}
      #{@course.errors[field].first}</span>"
  end

  # Active course status
  def active_course_status
    @course.id ? false : true
  end

  # Fill course status color on cell table
  def fill_course_status_color course
    if course.init?
      "primary"
    elsif course.studying?
      "success"
    elsif course.finish?
      "danger"
    else
      "default"
    end
  end

  def subject_studying course_subjects
    course_subjects.each do |course_subject|
      return course_subject.subject_users
    end
  end
end
