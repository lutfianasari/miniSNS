class ApplicationController < ActionController::Base
  protect_from_forgery

  def logout
    session[:login] = nil
    redirect_to "/members/login"
  end

  def login?
    if session[:login] != nil then
      return true
    else
      return false 
    end
  end

  def me? obj = nil
    id_num = obj != nil ? obj.member_id : params[:id].to_i
    if session[:login].id == id_num then
      return true
    else
      return false
    end
  end

  def admin?
    if session[:login].admin then
      return true
    else
      return false
    end
  end

  def checklogin?
    if session[:login] != nil then
      return true
    else
      redirect_to '/members/login'
      return false
    end
  end

  def checkme? obj = nil
    id_num = obj != nil ? obj.member_id : params[:id].to_i
    if session[:login].id == id_num then
      return true
    else
      redirect_to '/members/' + session[:login].id.to_s
      return false
    end
  end

  def checkadmin?
    if session[:login].admin then
      return true
    else
      redirect_to '/members/' + session[:login].id.to_s
      return false
    end
  end
end
