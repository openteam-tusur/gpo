class Person < ActiveRecord::Base
  belongs_to :chair

  def user
    User.find_by(:id => user_id)
  end

  def initials_name
    @initials_name ||= "#{last_name} #{initials}"
  end

  def initials
    @initials ||= [first_name.try(:first), middle_name.try(:first)].select(&:present?).map{|letter| "#{letter}."}.join
  end
end
