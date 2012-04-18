class AlphaNameValidator < ActiveModel::EachValidator
  # implement the method called during validation
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'must be english alphabet characters only' unless value ~= /^\w+$/
  end
end
