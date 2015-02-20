class AlienParticipant < Participant
  attr_accessible :university

  validates_presence_of :first_name, :last_name, :middle_name, :university, :faculty, :subfaculty, :edu_group

  def text_for_order_report
    "#{self.name}, #{university}, #{faculty}, #{subfaculty}, гр #{edu_group}"
  end

  def text_for_views
    "#{self.name}, #{university}, #{faculty}, #{subfaculty}, гр #{edu_group}"
  end

  def need_validation_of_student_id?
    false
  end

  def similar_participants
    Participant.where(:last_name => last_name, :first_name => first_name, :middle_name => middle_name)
  end
end
