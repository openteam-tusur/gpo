# encoding: utf-8
class Student < ActiveResource::Base

  self.site = "http://students.openteam.ru/"

  def to_param
    self.contingent_id
  end

  def new_record?
    false
  end

  def name
    "#{self.last_name} #{self.first_name} #{self.mid_name}"
  end

  def course
    self.year.to_i
  end

  def self.find_by_query(query)
    condition = []
    query.each do |key, value|
      condition << "#{key} = '#{value}'"
    end
    self.find(:all, :conditions => condition.join(" and "), :order => :last_name)
  end

  def destroyed?
    false
  end

  # Разрешения
  def self.listable_by?(user, context = nil)
    user.is_a?(User) && (user.admin? || user.supervisor?)
  end

end
