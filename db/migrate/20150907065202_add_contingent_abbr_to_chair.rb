class AddContingentAbbrToChair < ActiveRecord::Migration
  def change
    add_column :chairs, :contingent_abbr, :string
  end
end
