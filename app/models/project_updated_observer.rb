class ProjectUpdatedObserver < ActiveRecord::Observer
  observe :participant, :manager, :stage

  def after_save(record)
    record.project.updated_at = Time.now
    record.project.save
  end

  def before_destroy(record)
    if record.is_a? Stage
      record.project.updated_at = Time.now
      record.project.save
    end
  end

end

