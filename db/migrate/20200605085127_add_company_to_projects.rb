class AddCompanyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :company, :string
  end
end
