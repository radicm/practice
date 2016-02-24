require_relative '../common'

module Api
  module Generators
    class RelationGenerator < Rails::Generators::NamedBase
      include Api::Generators::Common
      source_root File.expand_path('../templates', __FILE__)

      argument :model, type: :string, required: true
      argument :version, type: :string, default: 'v1'
      argument :app_api_name, type: :string, default: 'grape_api'

      class_option :api_class, type: :string, required: false
      class_option :actions, type: :array, default: %w(index create show update destroy)
      class_option :endpoints, type: :boolean, default: true
      class_option :collection, type: :boolean, default: true
      class_option :relations, type: :array, default: []
      class_option :children, type: :array, default: []
      class_option :shared, type: :boolean, default: false

      def create_relation
        template('relation_endpoints.erb', "#{endpoint_path}/#{api_class_name.underscore}.rb") if options['endpoints']
      end

      private

      def relation_class_name
        file_name.camelize
      end

      def class_name
        model.camelize.constantize.relations[file_name].class_name
      end

      def parent_name
        options['model']
      end

      def api_class_name
        options['api_class'].blank? ? (model.camelize + relation_class_name.pluralize) : options['api_class'].camelize
      end

    end
  end
end
