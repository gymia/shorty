module ActiveModelErrorsExtension
  def has_error_on_attribute?(error, attribute)
    details[attribute].any? { |error_detail| error_detail[:error] == error }
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveModel::Errors.include ActiveModelErrorsExtension
end
