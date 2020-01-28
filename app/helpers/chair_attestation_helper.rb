module ChairAttestationHelper
  def student_achievement_links(stage, type, participant)
    out = ""
    stage.send(type).joins(:participants).where(participants: {id: participant}).each do |student_achievement|
      out << content_tag(:p,
                        link_to(student_achievement.title,
                                edit_manage_student_achievement_path(student_achievement),
                                style: 'text-decoration: underline'
                          )
                        )
    end
    out.html_safe
  end
end
