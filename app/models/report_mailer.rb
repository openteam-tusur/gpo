class ReportMailer < ActionMailer::Base

  def contingent_sync(content)
    @subject = "GPO contingent sync"
    @body[:content] = content
    @bcc = Rule.administrators.collect {|rule| rule.user.email}
    @bcc = @bcc.flatten.compact.uniq
    @recipients = ""
    @from = "openteam@tusur.ru"
    @sent_on = Time.now
  end

  def application_error(exception)
    @subject = "GPO application error"
    @body[:exception] = exception
    @bcc = Rule.administrators.collect {|rule| rule.user.email}
    @bcc = @bcc.flatten.compact.uniq
    @recipients = ""
    @from = "openteam@tusur.ru"
    @sent_on = Time.now
  end

end

