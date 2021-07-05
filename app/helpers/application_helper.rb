module ApplicationHelper
  TYPES_FLASH = {notice: :success, alert: :danger}.freeze

  def flash_class_name(name)
    TYPES_FLASH[name.to_sym] || name
  end
end
