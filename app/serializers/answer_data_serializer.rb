class AnswerDataSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :user_id, :question_id, :body, :best, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files

  def comments
    object.comments.pluck(:body)
  end

  def links
    object.links.pluck(:url)
  end

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
