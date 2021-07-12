class ActiveStorage::AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  def destroy
    @attachment.purge if authorize! :destroy, @attachment
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end