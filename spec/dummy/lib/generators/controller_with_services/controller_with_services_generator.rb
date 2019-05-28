require 'pp'

class ControllerWithServicesGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :models, type: :array, aliases: '-m', desc: '利用するモデル'

  def create_controller
    template 'controller.erb', controller_path
  end

  def create_interactor
    actions.each do |action|
      @action = action
      template 'interactor.erb', interactor_path(action)
      @action = nil
    end
  end

  def create_repositories
    options[:models].to_a.each do |model|
      actions.each do |action|
        @action = action
        @model = model.to_s
        template 'repository.erb', repository_path(action, model.to_s)
        @action = nil
        @model = nil
      end
    end
  end

  private

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

  # @return [Pathname]
  def repositories_path
    pathname('repositories')
  end

  # @return [Array<Hash>]
  def repository_attributes
    options[:models].to_a.flatten.map do |model|
      actions.map do |action|
        {
            const: repository_const(action, model.to_s),
            path: repository_path(action, model.to_s)
        }
      end
    end
  end

  # @param [String]
  # @param [String]
  # @return [Pathname]
  def repository_path(action, model)
    repositories_path.join(action).join(repository_file_name(model, true))
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

  # @param [String]
  # @return [String]
  def repository_file_name(model, extension_additional = false)
    file_name(model, 'repository', extension_additional)
  end

  # @param action [String]
  # @param model [String]
  # @return [String]
  def repository_const(action, model)
    [
        controller_const,
        action.camelize,
        repository_file_name(model).camelize
    ].join('::')
  end

  # @return [Pathname]
  def interactors_path
    pathname('interactors')
  end

  # @param action [String]
  # @return [Pathname]
  def interactor_path(action)
    interactors_path.join(interactor_file_name(action, true))
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

  def interactor_attributes
    actions.map do |action|
      {
          const: interactor_const(action),
          path: interactor_path(action)
      }
    end
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
end
