class RubyNameValidator < ActiveModel::EachValidator
  # implement the method called during validation
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'must be Mr. Mrs. or Dr.' unless value ~= /^[\w_!\?]+$/
  end
end
