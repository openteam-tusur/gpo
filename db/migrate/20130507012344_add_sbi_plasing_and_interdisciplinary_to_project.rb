class AddSbiPlasingAndInterdisciplinaryToProject < ActiveRecord::Migration
  def change
    add_column :projects, :sbi_placing, :string
    add_column :projects, :interdisciplinary, :string
  end
end
