module ParticipantsHelper
  def participant_cancel_state_button(button_name, participant)
    participant_change_state_form(cancel_chair_project_participant_url(participant.project.chair, participant.project, participant), button_name)
  end
  
  def participant_approve_state_button(button_name, participant)
    participant_change_state_form(approve_chair_project_participant_url(participant.project.chair, participant.project, participant), button_name)
  end
  
  def participant_change_state_form(url, button_name)
    out = ""
    out << form_tag(url, :method => :put)
    out << submit_tag(button_name)
    out << "</form>"
    out
  end

  def problem_text(participant)
    participant.problems.collect { |p| icon(:warning) + "<span>#{p}</span>" }.join
  end
end
