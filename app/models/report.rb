class Report < ActiveRecord::Base
  belongs_to :message_template, :polymorphic => true
  belongs_to :device, :polymorphic => true
  has_one :scheduler

  def perform
    if (message_template != nil && device != nil)
      begin
        device_hash = device.get_hash
        subject = message_template.render_subject(device_hash)
        body = message_template.render_body(device_hash)
        if (subject != nil && body != nil)
          mail = DefaultMailer.send_email(message_template.address, subject, body)
          result = "#{mail.header.fields.to_s.force_encoding("UTF-8")}\n\n #{mail.body.to_s}"
        end
      rescue => exception
        result = exception.message
      end
      result
    end
  end
end
