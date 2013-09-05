class Scheduler < ActiveRecord::Base
  belongs_to :schedulable, :polymorphic => true
end
