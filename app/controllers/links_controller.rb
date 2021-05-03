# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link

  def destroy
    authorize! :destroy, @link

    @link.destroy
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end
