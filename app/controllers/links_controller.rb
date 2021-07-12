class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :link
  def destroy
    link.destroy
  end

  private

  def link
    @link = Link.find(params[:id])
  end

  # helper_method :link
end