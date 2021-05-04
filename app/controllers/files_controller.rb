# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_file

  def destroy
    authorize! :destroy, @file

    @file.purge
  end

  def set_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
