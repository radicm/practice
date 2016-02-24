require_relative '../common'

module Api
  module Generators
    class SharedParamsEntityGenerator < Rails::Generators::Base
      include Api::Generators::Common
      source_root File.expand_path('../templates', __FILE__)

      argument :version, type: :string, default: 'v1'
      argument :app_api_name, type: :string, default: 'grape_api'

      def create_shared_params_entity
        template('shared_params_entity.erb', "#{entity_path}/shared_params.rb")
      end
    end
  end
end
