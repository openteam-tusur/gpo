Factory.define :rule do |rule|
  rule.user { |u| u.association(:user) }
  rule.role 'admin'
  rule.context_id ''
  rule.context_type ''
end

Factory.define :rule_mentor, :class => Rule do |rule|
  rule.role 'mentor'
  rule.context_type Chair.name
  rule.context_id {|c| c.association(:chair).id }
end

Factory.define :rule_manager, :class => Rule do |rule|
  rule.role 'manager'
  rule.context_type Project.name
  rule.context_id {|p| p.association(:project).id }
end

Factory.define :rule_admin, :class => Rule do |rule|
  rule.role 'admin'
#  rule.context nil
end

Factory.define :rule_supervisor, :class => Rule do |rule|
  rule.role 'supervisor'
#  rule.context nil
end
