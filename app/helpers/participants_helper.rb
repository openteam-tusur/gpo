# encoding: utf-8

module ParticipantsHelper
  def problem_text(participant)
    safe_join participant.problems.collect { |p| icon(:warning) + content_tag(:span, p) }
  end
end
