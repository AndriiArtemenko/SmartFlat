class ReportsDevice < ActiveRecord::Base
  belongs_to :device
  belongs_to :report
end