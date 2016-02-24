require_relative '../common'

module Api
  module Generators
    class EndpointGenerator < Rails::Generators::NamedBase
      include Api::Generators::Common
      source_root File.expand_path('../templates', __FILE__)

      argument :version, type: :string, default: 'v1'
      argument :app_api_name, type: :string, default: 'grape_api'

      class_option :api_class, type: :string, required: false
      class_option :actions, type: :array, default: %w(index create show update destroy)
      class_option :endpoints, type: :boolean, default: true
      class_option :collection, type: :boolean, default: true
      class_option :model, type: :boolean, default: true
      class_option :relations, type: :array, default: []
      class_option :request_relations, type: :array, default: nil
      class_option :response_relations, type: :array, default: nil
      class_option :children, type: :array, default: []
      class_option :shared, type: :boolean, default: false
      class_option :policy, type: :boolean, default: true

      def create_endpoints
        template('endpoints.erb', "#{endpoint_path}/#{api_class_name.underscore}.rb") if options['endpoints']
      end

      def create_relation_endpoints
        # ap "#{class_name}|#{r.class_name}|#{r.class}";
        return unless include_relations?
        remapped_relations(:has_many).each { |r| Rails::Generators.invoke 'api:relation', [r.class_name, class_name, version, app_api_name] if make_relation?(r.class_name) }
        remapped_relations(:has_one).each { |r| Rails::Generators.invoke 'api:relation', [r.class_name, class_name, version, app_api_name] if make_relation?(r.class_name) } # options['relations'].empty? ? true : options['relations'].include?(r.class_name) }
      end

      def create_model_entity
        request_relations = options['request_relations'].join(' ') unless options['request_relations'].blank?
        response_relations = options['response_relations'].join(' ') unless options['response_relations'].blank?

        Rails::Generators.invoke 'api:entity', [class_name, options['model'] ? '--model' : '', options['model'] ? '--collection' : '', options['request_relations'] ? "--request_relations=#{request_relations}" : '', options['response_relations'] ? "--response_relations=#{response_relations}" : ''] if options['model'] || options['collection']
      end

      def create_shared_params_entity
        Rails::Generators.invoke 'api:shared_params_entity', [] if options['shared']
      end

      def create_policy
        Rails::Generators.invoke 'api:policy', [class_name] if options['policy']
      end

      private

      def api_class_name
        options['api_class'].blank? ? class_name.pluralize : options['api_class'].camelize
      end

    end
  end
end
