module ChairAttestationHelper
  def student_achievement_links(stage, type, participant)
    out = ""
    participant.student_achievements.send(type).where(stage_id: stage.id).each do |student_achievement|
      out << content_tag(:p,
                        link_to(student_achievement.title,
                                edit_manage_student_achievement_path(student_achievement),
                                style: 'text-decoration: underline'
                          )
                        )
    end
    out.html_safe
  end

  def deleted_student_achievement_links(stage, type, participant)
    out = ""
    participant.student_achievements.send(type).where(stage_id: stage.id).each do |student_achievement|
      if student_achievement.scan.file?
        out << content_tag(:p,
                          link_to(student_achievement.title,
                                  student_achievement.scan.url,
                                  style: 'text-decoration: underline'
                            )
                          )
      else
        out << content_tag(:p,student_achievement.title)
      end
    end
    out.html_safe
  end
end
