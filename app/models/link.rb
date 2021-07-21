class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def is_gist?
    URI.parse(url).host.include?('gist')
  end

  def gist_id
    URI.parse(url).path.split('/').last
  end
end
