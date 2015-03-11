class MenusController < ApplicationController
  def show
  end
  def menu_selected
    session[:year]  = params[:year]
    session[:month] = params[:month]
    if params[:selected] == 'edit_worklogs'
      redirect_to controller: 'worklogs', action: 'index_edit' and return
    end
    render 'show'
  end
end
