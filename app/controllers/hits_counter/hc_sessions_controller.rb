module HitsCounter
  class HcSessionsController < ApplicationController
    def login
      username = params[:username].to_s.strip
      if username == Rails.configuration.hc_username and params[:password] == Rails.configuration.hc_password
        session[:hc_username] = username
      else
        flash[:alert] = 'Wrong username or password!'
      end
      redirect_to '/hits_report'
    end

    def logout
      session[:hc_username] = nil
      redirect_to '/hits_report'
    end
  end
end
