module Api
  module Generators
    module Common
      include ::Generators::Relations

      private

      def entity_path
        "app/api/#{app_api_name}/api/#{version}/entities"
      end

      def endpoint_path
        "app/api/#{app_api_name}/api/#{version}/"
      end

      def policy_path
        'app/policies'
      end

      def api_namespace
        "#{app_api_name.camelize}::API::#{version.capitalize}"
      end

      def entities_namespace
        "#{api_namespace}::Entities"
      end

      def entity_name
        "#{entities_namespace}::#{class_name}"
      end

      def entity_collection_name
        "#{entities_namespace}::#{class_name}Collection"
      end


      # Data preparation for template

      def fields
        class_name.constantize.fields
      end

      def visible_fields
        # fields.select{ |n, f| !n.start_with?('_') and (f.instance_of?(Mongoid::Fields::Standard) or !n.in?(relation_fields)) }
        fields.select { |n, f| !n.start_with?('_') && !n.in?(relation_fields) && f.instance_of?(Mongoid::Fields::Standard) }
      end

      def request_fields
        visible_fields.select { |n, _f| !n.in? %w(created_at updated_at) }
      end

      def include_relations?
        !options['relations'].empty?
      end

      def make_relation?(relation)
        options['relations'].include? relation
      end

      def make_request_relation?(relation)
        options['request_relations'].include? relation
      end

      def make_response_relation?(relation)
        options['response_relations'].include? relation
      end

      # def make_response_relation?(relation)
      #   options['relations'].include?(relation) or options['request-relations'].include?(relation)
      # end

      def has_many_relations
        remap_relations(relations_by_macro(:has_many))
      end

      def has_one_relations
        remap_relations(relations_by_macro(:has_one))
      end

      def belongs_to_relations
        remap_relations(relations_by_macro(:belongs_to))
      end

      def has_and_belongs_to_many_relations
        remap_relations(relations_by_macro(:has_and_belongs_to_many))
      end

      def remapped_relations(macro)
        remap_relations(relations_by_macro(macro))
      end

      def relations_by_macro(macro)
        all_relations.select { |_key, val| val.macro == macro }
      end

      def remap_relations(relations)
        relations.map do |_n, r|
          name = (r.as && !r.polymorphic? ? r.as : r.name).to_s
          OpenStruct.new(
            name: name,
            class_name: r.class_name,
            file_name: name.singularize,
            human_name: name.humanize,
            polymorphic?: r.polymorphic?,
            singular_key: "#{name.singularize}_id",
            plural_key: "#{name.singularize}_ids",
            included?: { response: included_relations(:response, name, :make_response_relation?),
                         request: included_relations(:request, name, :make_request_relation?) }
          # type: 0 object 1 object_id 2 object_ids
          )
        end
      end

      def included_relations(kind, name, func)
        [options["#{kind}_relations"].nil? ? true : send(func, name),
         options["#{kind}_relations"].nil? ? true : send(func, "#{name.singularize}_id"),
         options["#{kind}_relations"].nil? ? true : send(func, "#{name.singularize}_ids")]
      end

      def valid_request_relations(polymorphic, type, *macros)
        # macros.each do |relation|
        #   remapped_relations(relation).each do |val|
        #     yield val if val.polymorphic? == polymorphic and val.included?[type]
        #   end
        # end
        valid_relations(:request, polymorphic, type, *macros)
      end

      def valid_response_relations(polymorphic, type, *macros)
        valid_relations(:response, polymorphic, type, *macros)
      end

      def valid_relations(kind, polymorphic, type, *macros)
        set = macros.map { |relation| remapped_relations(relation) }.flatten.select { |val| val.polymorphic? == polymorphic && val.included?[kind][type] } # type: 0 object 1 object_id 2 object_ids
        if block_given?
          set.each { |val| yield val }
        else
          set
        end
      end

      # endpoint shared code

      def make_action?(action)
        options['actions'].include? action
      end

      def make_child?(action)
        options['children'].blank? || options['children'].include?(action)
      end

      def permit_params
        fields = request_fields.compact.map { |key, val| ":#{key}" if val.options[:type] != Array }.compact
        array_fields = request_fields.compact.map { |key, val| "#{key}: []" if val.options[:type] == Array }.compact

        # NOTE: uncomment if you need relation id in strong params
        # singular_relations = singular_relation(belongs_to_relations)
        # plural_relations = plural_relation(has_and_belongs_to_many_relations)d

        (fields + array_fields).join(', ')
      end

      def children_objects
        (singular_children(belongs_to_relations + has_one_relations + has_many_relations) + plural_children(has_and_belongs_to_many_relations)).compact
      end

      def singular_children(children)
        children.map do |r|
          "item.#{r.name} = #{r.class_name}.fetch(params[:#{r.singular_key}]) unless params[:#{r.singular_key}].blank?" if make_child?(r.file_name)
        end
      end

      def plural_children(children)
        children.map do |r|
          "item.#{r.name} << #{r.class_name}.fetch(params[:#{r.plural_key}]) unless params[:#{r.plural_key}].blank?" if make_child?(r.file_name)
          # "params[:#{r.plural_key}].each{ |n| item.#{r.name} << #{r.class_name}.fetch(n) } unless params[:#{r.plural_key}].blank?" if make_child?(r.file_name)
        end
      end

      def singular_relation(list)
        list.map { |r| ":#{r.singular_key}" unless r.polymorphic? }.compact
      end

      def plural_relation(list)
        list.map { |r| "#{r.plural_key}: []" unless r.polymorphic? }.compact
      end
    end
  end
end
