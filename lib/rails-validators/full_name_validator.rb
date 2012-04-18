class FullNameValidator < ActiveModel::Validator
  include ValidatorNameConfig
    
  def validate(record)
    [:first_name, :last_name].each do |attribute|
      value = record.send(attribute)

      record.errors[attribute] << "can't be blank" if value.blank?
      
      if !value.blank?      
        value = value.squeeze.strip
        record.errors[attribute] << "is too short" if value.size < min_length
        record.errors[attribute] << "is too long" if value.size > max_length
        record.errors[attribute] << "contains invalid characters" unless value =~ full_name_expr
      end
    end
  end

  def full_name_expr
    /^[a-zA-Z\-\s]*?$/
  end
end
