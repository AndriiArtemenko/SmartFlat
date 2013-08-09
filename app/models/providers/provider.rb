class Provider < ActiveRecord::Base
  belongs_to :receiver, :polymorphic => true
  has_many :provider_config
end