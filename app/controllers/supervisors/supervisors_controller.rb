class Supervisors::SupervisorsController < ActionController::Base
  include SessionsHelper
  before_action :is_supervisor?
  layout "supervisors"
end
