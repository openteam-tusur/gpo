# encoding: utf-8

class PasswordsController < ApplicationController

  def new
    @password = Password.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password }
    end
  end

  def create
    @password = Password.new(params[:password])
    @password.user = User.find_by_email(@password.email)

    respond_to do |format|
      if @password.save
        PasswordMailer.deliver_forgot_password(@password)
        flash[:notice] = "На Ваш почтовый ящик #{@password.email} отправлено сообщение с магической ссылкой"
        format.html { redirect_to(:action => 'new') }
        format.xml  { render :xml => @password, :status => :created, :location => @password }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @password.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reset
    begin
      @user = Password.find(:first, :conditions => ['reset_code = ? and expiration_date > ?', params[:reset_code], Time.now]).user
    rescue
      flash[:notice] = 'Магическая ссылка устарела или неверная.'
      redirect_to(new_password_path)
    end
  end

  def update_after_forgetting
    @user = Password.find_by_reset_code(params[:reset_code]).user
    @user.reset_password = true
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Пароль успешно обновлен'
        format.html { redirect_to login_url }
      else
        @user.password_confirmation = ""
        flash[:notice] = 'Ошибка обновления пароля'
        format.html { render(:action => :reset, :reset_code => params[:reset_code]) }
      end
    end
  end

  def update
    @password = Password.find(params[:id])

    respond_to do |format|
      if @password.update_attributes(params[:password])
        flash[:notice] = 'Пароль успешно обновлен'
        format.html { redirect_to(@password) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @password.errors, :status => :unprocessable_entity }
      end
    end
  end

end

