class ReportsController < ApplicationController

  # Get all schedulers.
  def list
    @reports = Report.all
    logger.debug("Show schedulers list : #{@reports}")
  end

  # Get scheduler by id.
  def edit
    @report = Report.find(params[:id])
  end

end
