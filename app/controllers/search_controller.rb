class SearchController < ApplicationController
  skip_authorization_check

  def index
    p 'search_body'
    p search_body

    @service = SearchService.new(search_body)
    @result = @service.call
  end

  private

  def search_body
    params.permit(:body, :type)
  end
end 