# ClientSideValidations Initializer

require 'client_side_validations/simple_form' if defined?(::SimpleForm)
require 'client_side_validations/formtastic'  if defined?(::Formtastic)

# Uncomment the following block if you want each input field to have the validation messages attached.
# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#   unless html_tag =~ /^<label/
#     %{<div class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></div>}.html_safe
#   else
#     %{<div class="field_with_errors">#{html_tag}</div>}.html_safe
#   end
# end

module ActiveModel::Validations::HelperMethods
  def validates_end_date_of(*attr_names)
    validates_with ValidDateValidator, _merge_attributes(attr_names)
  end
end


# module ClientSideValidations
#   module Formtastic
#     module FormBuilder
# 
#       def self.included(base)
#         base.class_eval do
#           def self.client_side_form_settings(options, form_helper)
#             {
#               :type => self.to_s,
#               :inline_error_class => "inline-errors"
#             }
#           end
#         end
#       end
# 
#     end
#   end
# end
# 
# Formtastic::FormBuilder.send(:include, ClientSideValidations::Formtastic::FormBuilder)

