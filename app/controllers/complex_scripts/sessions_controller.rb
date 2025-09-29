module ComplexScripts
  class SessionsController < ApplicationController
    allow_unauthenticated_access
    
    # GET /session/change_language/en
    def change_language
      session[:language] = params[:id] unless params[:id].blank?
      redirect_back fallback_location: root_url
    end
  end
end