module BlacklightConfigurationHelper
  include Blacklight::ConfigurationHelperBehavior

  # Overriding sort_field_label due to a bug:
  # see: https://github.com/projectblacklight/blacklight/issues/1810#issuecomment-392600689
  #
  # Should be removed again once this issue gets solved.
  def sort_field_label(key)
    field_config = blacklight_config.sort_fields[key]
    field_config ||= Blacklight::Configuration::NullField.new(key: key)

    field_label(
      :"blacklight.search.fields.sort.#{field_config.label}",
      (field_config.label if field_config),
      key.to_s.humanize
    )
  end
end