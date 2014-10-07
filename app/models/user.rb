class User
  include AuthClient::User

  def app_name
    'gpo'
  end

  def people
    Person.where(:user_id => id)
  end

  %w(project_manager manager mentor).each do |role|
    define_method "#{role}?" do
      permissions.for_role(role.to_sym).any?
    end

    define_method "#{role}_of?" do |context|
      permissions.for_role(role.to_sym).for_context(context).any?
    end
  end

  def available_chairs
    if manager?
      Chair.ordered_by_abbr
    elsif mentor?
      Chair.ordered_by_abbr.joins(:permissions).where(:permissions => {:user_id => id}).uniq
    elsif project_manager?
      Chair.ordered_by_abbr.joins(:projects).where(:projects => {:id => permissions.where(:context_type => 'Project').pluck(:context_id)}).uniq
    else
      []
    end
  end

  def initials_name
    @initials_name ||= "#{surname} #{initials}"
  end

  def initials
    @initials ||= [name.try(:first), patronymic.try(:first)].select(&:present?).map{|letter| "#{letter}."}.join
  end
end
