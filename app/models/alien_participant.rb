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

# == Schema Information
#
# Table name: participants
#
#  id                :integer          not null, primary key
#  student_id        :integer
#  state             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :integer
#  course            :integer
#  first_name        :string(255)
#  middle_name       :string(255)
#  last_name         :string(255)
#  edu_group         :string(255)
#  contingent_active :boolean
#  contingent_gpo    :boolean
#  undergraduate     :boolean
#  subfaculty        :string(255)
#  faculty           :string(255)
#  executive         :boolean          default(FALSE)
#  type              :string(255)
#  university        :string(255)
#
