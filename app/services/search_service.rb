class SearchService
  TYPES = ["All", "Question", "Comment", "Answer", "User"]

  def initialize(params)
    @type = params[:type]
    @body = params[:body]
  end

  def call

    if @body.empty?
      return []
    end
    @type == "All" ? ThinkingSphinx.search(@body) : Object.const_get(@type).search(@body)
  end
end 