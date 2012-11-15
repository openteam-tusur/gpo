# encoding: utf-8

require 'progress_bar'

namespace :contingent do
  desc "Synchronize students from contingent"
  task :sync => :environment do
    ActiveRecord::Base # FIXME: remove this line when https://github.com/rails/rails/issues/882 will be resolved
    Participant.observers.disable :all
    bar = ProgressBar.new(Participant.count)
    Participant.pluck(:student_id) do |student_id|
      Participant.contingent_find(:study_id => student_id, :include_inactive => true).map{|p| p.save!(:validate => false)}
      bar.increment!
    end
  end
end
