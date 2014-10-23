class User
  include AuthClient::User

  def app_name
    'gpo'
  end

  def people
    @people ||= Person.where(:user_id => id)
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
    return [] if permissions.empty?
    available_chairs = []
    available_chairs += Chair.all.map(&:id) if manager?
    available_chairs += Chair.joins(:permissions).where(:permissions => {:user_id => id}).map(&:id) if mentor?
    available_chairs += Chair.joins(:projects).where(:projects => {:id => permissions.where(:context_type => 'Project').pluck(:context_id)}).map(&:id) if project_manager?
    available_chairs = Chair.ordered_by_abbr.where(:id => [available_chairs.uniq])
  end

  def initials_name
    @initials_name ||= "#{surname} #{initials}"
  end

  def initials
    @initials ||= [name.try(:first), patronymic.try(:first)].select(&:present?).map{|letter| "#{letter}."}.join
  end

  def managable_projects
    project_managers.map(&:project)
  end

  def project_managers
    @project_managers ||= people.flat_map{ |p| p.project_managers.approved }
  end

  def after_signied_in
    super

    Person.where(:email => self.email, :user_id => nil).each do |person|
      person.update_columns(:user_id => self.id)
      person.project_managers.approved.each do |pm|
        self.permissions.reload.find_or_create_by!(:role => :project_manager, :context_type => 'Project', :context_id => pm.project_id)
      end
    end
  end
end
