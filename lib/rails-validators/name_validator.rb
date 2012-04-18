class NameValidator < ActiveModel::EachValidator
  # implement the method called during validation
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'contains illegal characters' unless value ~= /^[\s^0-9`!@#\$%\^&*+_=]+$/
  end
end
