class ControllerWithServicesGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :models, type: :array, aliases: '-m', desc: '利用するモデル'

  def create_controller
    template 'controller.erb', controller_path
  end

  def create_interactor
    actions.each &method(:gen_interactor)
  end

  def create_repositories
    options[:models].to_a.each &method(:gen_repositories)
  end

  def create_responders
    actions.each &method(:gen_responder)
  end

  private

  def gen_interactor(action)
    generate 'interactor', "#{controller_name}##{action}"
  end

  def gen_repositories(model)
    actions.each { |action| gen_repository(action, model) }
  end

  def gen_repository(action, model)
    generate 'repository', "#{controller_name}##{action}-#{model}"
  end

  def gen_responder(action)
    generate 'responder', "#{controller_name}##{action}"
  end

  # @return [String]
  def controller_name
    controller_const.underscore.singularize
  end

  # @return [Pathname]
  def controller_path
    app_path.join('controllers').join("#{controller_name}.rb")
  end

  # @return [String]
  def controller_const
    [name.to_s.camelize.pluralize, 'Controller'].join
  end

  # @return [Array<String>]
  def actions
    allow_actions.select { |action| args.map(&:to_s).map(&:squish).include?(action) }.to_a
  end

  # @return [Array<String>]
  def allow_actions
    %w(index show create update destroy)
  end

  # @return [Pathname]
  def app_path
    Rails.root.join('app')
  end

  # @param service [String]
  # @return [Pathname]
  def pathname(service)
    app_path.join(service).join(controller_const.underscore)
  end

  # @param base [String]
  # @param klass [String]
  # @param extension [String]
  # @return [String]
  def file_name(base, klass, extension_additional = false, extension: 'rb')
    [
        [base.singularize, klass].join('_'),
        extension_additional ? extension : nil
    ].reject(&:blank?).join('.')
  end

  # @return [Pathname]
  def responders_path
    pathname('responders')
  end

  # @param action [String]
  # @return [Pathname]
  def responder_path(action)
    responders_path.join(action).join(interactor_file_name(action, true))
  end

  # @param action [String]
  # @return [String]
  def responder_file_name(action, extension_additional = false)
    file_name(action, 'responder', extension_additional)
  end

  # @param action [String]
  # @return [String]
  def responder_const(action)
    [
        controller_const,
        responder_file_name(action).camelize
    ].join('::')
  end

  def responder_attributes
    actions.map do |action|
      {
          const: responder_const(action),
          path: responder_path(action)
      }
    end
  end

  # @param action [String]
  # @return Symbol
  def http_methods(action)
    {
        index: :GET,
        show: :GET,
        create: :POST,
        update: :PUT,
        destroy: :DELETE
    }[action.to_sym]
  end

  # @return [String]
  def routing_prefix
    "/#{controller_name.gsub(/_controller/, '')}"
  end

  # @param action [String]
  # @return [Maybe<String>]
  def routing_suffix(action)
    {
        index: nil,
        show: ':id',
        create: nil,
        update: nil,
        destroy: ':id'
    }[action.to_sym]
  end

  def routing_path(action)
    [
        routing_prefix,
        routing_suffix(action)
    ].reject(&:blank?).join('/')
  end

  # @param action [String]
  # @return [String]
  def interactor_file_name(action, extension_additional = false)
    file_name(action, 'interactor', extension_additional)
  end

  # @param action [String]
  # @return [String]
  def interactor_const(action)
    [
        controller_const,
        interactor_file_name(action).camelize
    ].join('::')
  end
end
