# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session

      before_action :doorkeeper_authorize!

      private

      def current_ability
        @current_ability ||= Ability.new(current_resource_owner)
      end

      def current_resource_owner
        if doorkeeper_token
          @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
        end
      end
    end
  end
end
