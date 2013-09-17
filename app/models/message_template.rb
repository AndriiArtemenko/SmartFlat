class MessageTemplate < ActiveRecord::Base

  # Render subject of message with params.
  def render_subject(params)
    render_custom(subject, params)
  end

  # Render body of message with params.
  def render_body(params)
    render_custom(body, params)
  end

  protected

  # Replaces variables in the template
  def render_custom(template, params)
    if (template != nil)
      blank = Liquid::Template.parse(template)
      blank.render(params)
    end
  end

end
