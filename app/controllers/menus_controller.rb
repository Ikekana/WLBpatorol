class MenusController < ApplicationController
  def show
    session[:date] = nil
    session[:year] = Date.today.year
    session[:month] = Date.today.month
  end
  
  # ログイン時に以降の操作のデフォルトとなる年月を設定する
  def menu_selected
    if params[:year].nil?
      session[:year] = Dte.today.year
    else
      session[:year] = params[:year]
    end    
    if params[:month].nil?
      session[:month] = Date.today.month
    else
      session[:month] = params[:month]
    end    

    redirect_to controller: 'worklogs', action: 'index_edit' and return

  end
end
