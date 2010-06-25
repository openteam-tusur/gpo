require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'activesupport'

namespace :students do
  desc "Synchronize students from contingent"
  task :synchronize => :environment do
    Project.delete_observers
    Participant.delete_observers
    ret = []
    id = ""
    participants = ENV["PROJECT_ID"].blank? ? Participant.find(:all) : Project.find(ENV["PROJECT_ID"]).participants
    begin
      participants.each do |participant|
        id = participant.id
        p participant
        participant.update_from_contingent
        participant.save!
      end
      ret << "все успешно обновлено"
    rescue Exception => e
      ret << "ошибка обновления #{id}\n"
      ret << e.backtrace.join("\n")
    end
    if ENV["PROJECT_ID"].blank?
      ReportMailer.deliver_contingent_sync(ret)
    else
      puts ret.join("\n")
    end
  end

end
