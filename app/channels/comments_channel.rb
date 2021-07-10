class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments-#{params[:question_id]}"
  end
end
