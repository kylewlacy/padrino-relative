# Copy/pasta from https://github.com/padrino/padrino-framework
# File is padrino-core/lib/padrino-core/application/routing.rb
# Modified based on https://github.com/kylewlacy/padrino-framework
module Padrino
  module Routing
    module ClassMethods
        def parse_route(path, options, verb)
          # We need save our originals path/options so we can perform correctly cache.
          original = [path, options.dup]

          # options for the route directly
          route_options = {}

          # We need check if path is a symbol, if that it's a named route
          map = options.delete(:map)

          relative_path = false
          if map == :index
            map = '/'
            relative_path = true
          end

          if path.kind_of?(Symbol) # path i.e :index or :show
            name = path                                                # The route name
            path = map ? map.dup : (path == :index ? '/' : path.to_s)  # The route path
          end

          # Build our controller
          controller = Array(@_controller).map { |c| c.to_s }

          case path
          when String # path i.e "/index" or "/show"
            # Now we need to parse our 'with' params
            if with_params = options.delete(:with)
              path = process_path_for_with_params(path, with_params)
            end

            # Now we need to parse our provides
            options.delete(:provides) if options[:provides].nil?

            if @_use_format or format_params = options[:provides]
              process_path_for_provides(path, format_params)
              options[:matching] ||= {}
              options[:matching][:format] = /[^\.]+/
            end

            absolute_map = map && map[0] == ?/

            unless controller.empty?
              # Now we need to add our controller path only if not mapped directly
              if !absolute_map or relative_path
                controller_path = controller.join("/")
                path.gsub!(%r{^\(/\)|/\?}, "")
                path = File.join(controller_path, path)
              end
              # Here we build the correct name route
            end

            # Now we need to parse our 'parent' params and parent scope
            if !absolute_map and parent_params = options.delete(:parent) || @_parents
              parent_params = Array(@_parents) + Array(parent_params)
              path = process_path_for_parent_params(path, parent_params)
            end

            # Add any controller level map to the front of the path
            path = "#{@_map}/#{path}".squeeze('/') unless absolute_map or @_map.blank?

            # Small reformats
            path.gsub!(%r{/\?$}, '(/)')                  # Remove index path
            path.gsub!(%r{//$}, '/')                     # Remove index path
            path[0,0] = "/" if path !~ %r{^\(?/}         # Paths must start with a /
            path.sub!(%r{/(\))?$}, '\\1') if path != "/" # Remove latest trailing delimiter
            path.gsub!(/\/(\(\.|$)/, '\\1')              # Remove trailing slashes
            path.squeeze!('/')
          when Regexp
            route_options[:path_for_generation] = options.delete(:generate_with) if options.key?(:generate_with)
          end

          name = options.delete(:route_name) if name.nil? && options.key?(:route_name)
          name = options.delete(:name) if name.nil? && options.key?(:name)
          if name
            controller_name = controller.join("_")
            name = "#{controller_name}_#{name}".to_sym unless controller_name.blank?
          end

          # Merge in option defaults
          options.reverse_merge!(:default_values => @_defaults)

          [path, name, options, route_options]
        end
    end
  end
end
