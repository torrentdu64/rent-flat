class RegistrationsController < Devise::RegistrationsController

  def create
    super #We call super because we don't want to override this action
  end

  def edit
    super
    #Custom code to override this action
  end

  def update
    super
    byebug
  end

end