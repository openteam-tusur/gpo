class PasswordMailer < ActionMailer::Base

  def forgot_password(password)
    setup_email(password.user)
    @subject    += 'Магическая ссылка'
    @body[:url]  = "http://gpo.tusur.ru/change_password/#{password.reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject << 'Пароль сброшен'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "noreply@gpo.tusur.ru"
      @subject     = "[gpo.tusur.ru] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end

