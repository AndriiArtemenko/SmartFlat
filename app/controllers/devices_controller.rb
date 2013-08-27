class DevicesController < ApplicationController
  before_filter :authenticate_user!

  def new
    class_name = params[:device][:type]
    if (class_name != nil)
      device_class = Object.const_get(class_name)
      puts device_class <= Device
      if (device_class <= Device)
        device = device_class.new
        device.id = Device.last.id + 1
        device.name = params[:device][:name]
        device.status = Device::Status::OFF
      end
    end
    if (device)
      redirect_to :action => :edit, :id => device.id
    end
  end

  def list
    @devices_list = [Boiler.to_s, Meter.to_s]
    @devices = Device.all
    logger.debug("Show devices list : #{@devices}")
  end

  def edit
    @device = Device.find(params[:id])
    logger.debug("Render : #{@device}")
    render "#{@device.class.to_s.downcase}s/edit"
  end

  def image
    @device = Device.find(params[:id])
    send_data @device.icon, :type => 'image/png',:disposition => 'inline'
  end

  def update
    @device = Device.find(params[:id])
    device_attr = params[@device.class.to_s.downcase]
    @device.attributes = device_attr
    @device.authorized_user = current_user.email
    if (!@device.save)
      @device.reload
    end
    render "#{@device.class.to_s.downcase}s/edit"
  end

end