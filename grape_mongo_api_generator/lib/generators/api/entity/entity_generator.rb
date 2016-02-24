require_relative '../common'

module Api
  module Generators
    class EntityGenerator < Rails::Generators::NamedBase
      include Api::Generators::Common
      source_root File.expand_path('../templates', __FILE__)

      # argument :model, type: :string, required: true
      argument :version, type: :string, default: 'v1'
      argument :app_api_name, type: :string, default: 'grape_api'

      class_option :collection, type: :boolean, default: true
      class_option :model, type: :boolean, default: true
      class_option :concerns, type: :boolean, default: false
      # class_option :relation, type: :boolean, default: true
      class_option :response_relations, type: :array, default: nil
      class_option :request_relations, type: :array, default: nil

      def create_collection_entity
        template('collection_entity.erb', "#{entity_path}/#{file_name}_collection.rb") if options['collection']
      end

      def create_model_entity
        template('model_entity.erb', "#{entity_path}/#{file_name}.rb") if options['model']
      end

      def create_concerns_model_entity
        template('concerns_model_entity.erb', "#{entity_path}/concerns/#{file_name}.rb") if !File.exist?("#{entity_path}/concerns/#{file_name}.rb") && options[:concerns]
      end

      private

      def extract_validators(model)
        model.validators.each do |n|
          n.attributes.each do |a|
            @validators[a] ||= []
            @validators[a] << n
          end
        end
      end

      def validators
        return @validators unless @validators.nil?
        @validators = {}
        extract_validators(class_name.constantize)
        @validators
      end

      def find_validator(param, name)
        (validators[param.to_sym] || []).find { |x| x.class.name.demodulize == name }
      end

      def field_required?(param)
        !!find_validator(param, 'PresenceValidator') || !!fields[param].try(:default_val)
      end

      def field_regex(param)
        ([find_validator(param, 'FormatValidator')] || []).compact.map { |x| x.options[:with] }.first
      end

      def length_field_regex(param)
        ([find_validator(param, 'LengthValidator')] || []).compact.map { |x| "/^\\w{#{x.options[:minimum]},#{x.options[:maximum]}}$/" }.first
      end

      def request_params
        @request_params ||= request_fields.collect do |key, value|
          OpenStruct.new(name: key, type: key == '_id' ? 'String' : value.options[:type], default_value: value.options[:default])
        end
      end

      def params
        @params ||= visible_fields.collect do |key, value|
          OpenStruct.new(name: key, type: key == '_id' ? 'String' : value.options[:type], default_value: value.options[:default])
        end
      end

    end
  end
end
