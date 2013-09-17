class Report < ActiveRecord::Base
  belongs_to :message_template, :polymorphic => true
  has_many :reports_devices
  has_many :devices, :through => :reports_devices
  has_one :scheduler

  # Execute report.
  def perform
    if (message_template != nil && devices != nil)
      begin
        devices_hash = prepared_data
        devices_hash = (devices_hash != nil) ? devices_hash : Hash.new
        subject = message_template.render_subject(devices_hash)
        body = message_template.render_body(devices_hash)
        if (subject != nil && body != nil)
          mail = DefaultMailer.send_email(message_template.address, subject, body)
          result = "#{subject}\n #{body}"
        end
      rescue => exception
        result = exception.message
      end
      result
    end
  end

  def sources
    result = ''
    if(devices != nil)
      devices.each { |device| result = result + "#{device.name}\n" }
      end
      result
  end

  private

  # Provide devices data hash.
  def prepared_data
    hash_list = Array.new
    devices.each { |device| hash_list << device.get_hash }

    data = Hash.new
    data['current_date'] = Time.now.strftime("%d.%m.%Y")
    data['devices'] = hash_list
    return data
  end

end
