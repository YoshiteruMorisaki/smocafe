class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name(enum_name, enum_value)
    I18n.t(
      enum_value,
      scope: [ "activerecord", "attributes", model_name.i18n_key, enum_name.to_s.pluralize ],
      default: enum_value.to_s.humanize
    )
  end
end
