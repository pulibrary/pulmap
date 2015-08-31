module Pulmap
  module Suggest
    module SearchHelper
      extend ActiveSupport::Concern
      include Blacklight::SearchHelper

      ##
      # For now, only use the q parameter to create a
      # Pulmap::Suggest::Response
      # @param [Hash] params
      # @return [Pulmap::Suggest::Response]
      def get_suggestions(params)
        request_params = { q: params[:q] }
        Pulmap::Suggest::Response.new suggest_results(request_params), request_params
      end

      ##
      # Query the suggest handler using RSolr::Client::send_and_receive
      # @param [Hash] request_params
      # @return [RSolr::HashWithResponse]
      def suggest_results(request_params)
        repository.connection.send_and_receive('suggest', params: request_params)
      end
    end
  end
end
