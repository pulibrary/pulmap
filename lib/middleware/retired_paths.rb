# frozen_string_literal: true

module Middleware
  # Return a 410 Gone response without errors with retired URLs
  class RetiredPaths
    def initialize(app)
      @app = app
    end

    def call(env)
      return response if path_prefixes.find { |prefix| env["PATH_INFO"].to_s.start_with?(prefix) }

      @app.call(env)
    end

    private

      def response
        [ 410, { "content-type" => "text/plain" }, [ "Gone" ] ]
      end

      def path_prefixes
        [
          "/rails/active_storage/"
        ]
      end
  end
end
