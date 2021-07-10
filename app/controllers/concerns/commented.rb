module Commented
  extend ActiveSupport::Concern

  included do
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def commentable
    id = model_klass.name.underscore.to_sym == :answer ? params[:answer_id] : params[:id]
    model_klass.find(id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    id = @comment.commentable_type.to_sym == :Answer ? @comment.commentable.question.id : @comment.commentable.id
    ActionCable.server.broadcast( 
      "comments-#{id}", {
        partial: ApplicationController.render( partial: 'comments/comment', locals: { comment: @comment, current_user: nil }),
        comment: @comment
    })
  end

end