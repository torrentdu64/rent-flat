class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :initialize_session
  before_action :load_cart


  def initialize_session
    session[:cart] ||= [] # empty cart = empty array
  end

  def load_cart
    #@cart = Flat.find(session[:cart]) || ""
  end

  # Pretty generic method to handle exceptions.
  # You'll probably want to do some logging, notifications, etc.
  def handle_error(message = "Sorry, something failed.", view = 'new')
    flash.now[:alert] = message
    render view
  end

end
