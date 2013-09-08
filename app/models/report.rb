class Report < ActiveRecord::Base
  belongs_to :message_template, :polymorphic => true
  belongs_to :device, :polymorphic => true

  def perform
    if (message_template != nil && device != nil)
      device_hash = device.get_hash
      subject = message_template.render_subject(device_hash)
      body = message_template.render_body(device_hash)
      if (subject != nil && body != nil)
        DefaultMailer.send_email(message_template.address, subject, body)
      end
    end
  end
end
