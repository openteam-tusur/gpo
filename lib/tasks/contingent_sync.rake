# encoding: utf-8

require 'progress_bar'

namespace :contingent do
  desc "Synchronize students from contingent"
  task :sync => :environment do
    ActiveRecord::Base # FIXME: remove this line when https://github.com/rails/rails/issues/882 will be resolved
    Participant.observers.disable :all
    bar = ProgressBar.new(Participant.count)
    Participant.find_each do |participant|
      Participant.contingent_find(:study_id => participant.student_id, :include_inactive => true).first.save!
      bar.increment!
      sleep(1) # FIXME: remove this line when nginx stops random crashing
    end
  end
end
