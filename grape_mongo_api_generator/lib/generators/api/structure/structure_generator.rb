require 'fileutils'
module Api
  module Generators
    class StructureGenerator < Rails::Generators::NamedBase

      source_root File.expand_path('../templates', __FILE__)
      argument :version, type: :string, required: true

      def create_api_structure
        FileUtils.mkdir_p(assistants_path) unless File.exist?(assistants_path)
        FileUtils.mkdir_p(entities_path) unless File.exist?(entities_path)
      end

      def create_api_files
        template('api.erb', "#{api_app_path}/api.rb")
        template('version.erb', "#{api_app_api_path}/#{version}.rb")
        template('shared_params.erb', "#{assistants_path}/shared_params.rb")
        template('authenticate.erb', "#{assistants_path}/authenticate.rb")
        template('shared_params_entity.erb', "#{entities_path}/shared_params.rb")
      end

      private

      def api_app_path
        "app/api/#{file_name}"
      end

      def api_app_api_path
        "#{api_app_path}/api"
      end

      def assistants_path
        "#{api_app_api_path}/#{version}/assistants"
      end

      def entities_path
        "#{api_app_api_path}/#{version}/entities"
      end

      def entities_concerns_path
        "#{api_app_api_path}/#{version}/entites/concerns"
      end

      def api_namespace
        "#{class_name}::API::#{version.capitalize}"
      end

      def entities_namespace
        "#{api_namespace}::Entities"
      end

      def assistants_namespace
        "#{api_namespace}::Assistants"
      end
    end
  end
end
