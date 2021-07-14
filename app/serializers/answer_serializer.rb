class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :question_id, :body, :best, :created_at, :updated_at
end
