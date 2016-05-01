class ApplicationController < ActionController::API
  before_action :enable_cross_access_control

  private
  def enable_cross_access_control
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
