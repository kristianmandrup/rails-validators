class CompanyNameValidator < ActiveModel::EachValidator
  include include RailsValidators::Helper::NameConfig

  def validate_each(record, attribute, value)
    record.errors[attribute] << "is too long" if value && value.size > max_length    
    record.errors[attribute] << "has invalid characters" unless value =~ company_name_expr
  end

  protected

  def company_name_expr 
  	/^[a-zA-Z0-9\_\-\ ]*?$/
  end
end

