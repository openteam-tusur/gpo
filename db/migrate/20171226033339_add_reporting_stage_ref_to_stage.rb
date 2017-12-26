class AddReportingStageRefToStage < ActiveRecord::Migration
  def change
    add_reference :stages, :reporting_stage, index: true
  end
end
