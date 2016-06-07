class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :cors_preflight_check
  after_filter :cors_set_access_headers

  def cors_set_access_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  def cors_preflight_check
  if request.method == :options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
    render :text => '', :content_type => 'application/xml'
  end
  end

end
