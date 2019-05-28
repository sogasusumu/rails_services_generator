class InteractorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_interactor
    template template_file, path
  end

  private

  # @return [String]
  def controller_name
    name.to_s.split('#').first.underscore.gsub(/_controller*/, '').pluralize
  end

  # @return [String]
  def action_name
    default_actions.delete(name.to_s.split('#').last).tap { |s| raise('action name err') unless s.present? }
  end

  # @return [Array<String>]
  def default_actions
    %w(index show create update destroy)
  end

  # @return [String]
  def service_name
    'interactor'
  end

  # @return [String]
  def file_name(additional = false, ext: 'rb')
    [action_name, service_name].join('_').tap { |str| str << ".#{ext}" if additional }
  end

  # @return [String]
  def template_file
    [
        service_name,
        'erb'
    ].join('.')
  end

  # @return [Pathname]
  def path
    Rails.root.join('app').join(service_name).join(controller_name.underscore).join(file_name(true))
  end

  # @return [String]
  def const
    [
        controller_name.camelize,
        file_name.camelize
    ].join('::')
  end
end
