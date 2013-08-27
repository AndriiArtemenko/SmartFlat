class Device < ActiveRecord::Base
  attr_accessor :authorized_user

  has_many :messages

  after_initialize :init
  before_save :before_save_callback
  after_save :after_save_callback

  validates :authorized_user, :exclusion => { :in => %w(guest@mail.com), :message => "don't has the necessary privileges" }

  module Status
    ON = 'ON'
    OFF = 'OFF'
    UNKNOWN = 'UNKNOWN'
    ERROR = 'ERROR'
  end
  @@statuses = [Status::ON, Status::OFF, Status::UNKNOWN, Status::ERROR]

  def sensorEvennt(sensor, value)
    message = Message.new
    message.value = "#{sensor}: #{value}" 
    message.date = DateTime.now
    self.messages << message
  end

  # Run after initialize.
  def init
  end

  # Run after record saved.
  def after_save_callback
  end

  # Run before record saved.
  def before_save_callback
  end

end
