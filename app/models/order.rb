require 'documatic'

class Order < ActiveRecord::Base
  set_table_name "ordinances"
  
  has_many :order_projects, :dependent => :destroy
  has_many :projects, :through => :order_projects, :order => "cipher desc"
  has_many :activities, :as => :context, :dependent => :destroy, :order => 'created_at desc'
  
  belongs_to :chair
  
  has_attached_file :file, :path => ":rails_root/public/:attachment/order_:id.:extension", :url => "/:attachment/order_:id.:extension"

  validates_presence_of :number, :approved_at, :if => :approved?

  has_states :draft, :being_reviewed, :reviewed, :approved, :removed do
    on :remove do
      transition :draft => :removed, :being_reviewed => :removed, :reviewed => :removed, :approved => :removed
    end
    on :to_review do
      transition :draft => :being_reviewed
    end
    on :cancel do
      transition :being_reviewed => :draft, :reviewed => :draft
    end
    on :review do
      transition :being_reviewed => :reviewed
    end
    on :approve do
      transition :reviewed => :approved
    end        
  end
  
  named_scope :blocking, :conditions => {:state => ['being_reviewed', 'reviewed' ]}
  named_scope :not_approved, :conditions => {:state => ['draft', 'being_reviewed', 'reviewed' ]}
  
  def state_description
    L10N[:order]["state_#{self.state}".to_sym]
  end
  
  def title
    raise "Некорректный тип приказа. Невозможно отобразить название приказа."
  end

  def order_type
    self.class.name
  end

  def update_projects(ids)
    self.projects = []
    unless ids.nil?
      ids.each { |id|
        self.projects << Project.find(id)
      }
    end
  end
  
  def projects_to_s
    ret = self.projects.collect { |p| p.cipher }
    if ret.length > 3
      left = ret.length - 2
      ret = ret[0..1]
      ret << "ещё #{left} #{Order.pluralized_string(left)}"
    end
    ret.to_sentence
  end
  
  def self.pluralized_string(n)
    Russian.p(n, 'проект', 'проекта', 'проектов')
  end

  def activity!(action, actor, comment)
    self.activities.create(:action => action.to_s, :actor => actor, :comment => comment, :chair => self.chair)
  end
  
  def after_enter_removed
    release_projects! if was_being_reviewed? || was_reviewed?
    self.destroy
  end
  
  def after_enter_being_reviewed
    block_projects!
    regenerate_file! unless self.file?
  end
  
  def after_enter_draft
    release_projects!
    remove_file! if self.file?
  end

  def regenerate_file!
    order = Order.find(self.id)
    odt_file = Tempfile.new('order_tempfile.odt')
    options = Ruport::Controller::Options.new(:template_file => "#{RAILS_ROOT}/lib/templates/orders/#{self.class.name.underscore}.odt",
      :output_file => odt_file.path )
    Documatic::OpenDocumentText::Template.process_template(:options => options, :data => order)

    odt_file.open
    order.file = odt_file
    order.save

    odt_file.close
  end

  def remove_file!
    order = Order.find(self.id)
    order.file = nil
    order.save
  end


  protected
  def release_projects!
    self.projects.each { |p| p.enable_modifications }
  end

  def block_projects!
    self.projects.each { |p| p.disable_modifications }
  end
  
  def validate
    errors.add("projects", "Должен быть выбран хотя бы один проект") if self.projects.empty?
  end
end
