Factory.define :participant do |participant|
  participant.student { |student| student.association(:student) }
  participant.project { |project| project.association(:project) }
  participant.state 'awaiting_approval'
end
