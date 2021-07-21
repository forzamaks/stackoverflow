module ApplicationHelper
  TYPES_FLASH = {notice: :success, alert: :danger}.freeze

  def flash_class_name(name)
    TYPES_FLASH[name.to_sym] || name
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximun(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
