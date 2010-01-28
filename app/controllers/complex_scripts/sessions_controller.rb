class ComplexScripts::SessionsController < ApplicationController
  
  # GET /session/change_language/en
  def change_language
    session[:language] = params[:id] unless params[:id].blank?
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end