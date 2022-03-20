require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Railsui # :nodoc:
  module Generators # :nodoc:
    class Base < Rails::Generators::NamedBase #:nodoc:
      protected

      def format
        :html
      end

      def handler
        :erb
      end

      def filename_with_extensions(name)
        cformat = name[/\.js/] ? nil : format
        [name, cformat, handler].compact.join(".")
      end
    end

    class ScaffoldGenerator < Base
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

     class_option :css, type: :string, default: nil, desc: "Pass CSS framework of choice"

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          if css == Railsui::Default::BOOTSTRAP
            template_path = "bootstrap/#{filename}"
          elsif css == Railsui::Default::BULMA
            template_path = "bulma/#{filename}"
          elsif css == Railsui::Default::TAILWIND_CSS
            template_path = "tailwind/#{filename}"
          else
            template_path = "none/#{filename}"
          end

          template template_path, File.join("app/views",controller_file_path, filename)
        end
      end

    protected
      def css
        options[:css]
      end

      def available_views
        %w(index edit show new _form)
      end
    end
  end
end