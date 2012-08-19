class ApplicationController < ActionController::Base
  respond_to :json , :xml 
  rescue_from Exception , :with => :unexpected_error
  rescue_from Mongoid::Errors::DocumentNotFound , :with => :resource_not_found 
  
  def unexpected_error(exception)
    respond_with( { :error => exception.message } , :status => 500)
  end
  
  def resource_not_found
    head 404
  end
  
end