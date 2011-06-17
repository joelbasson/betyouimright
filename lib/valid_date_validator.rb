class ValidDateValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if ((DateTime.parse(value.to_s) rescue ArgumentError) == ArgumentError)
      record.errors.add(attr_name, :end_date, options.merge(:value => value))
    else  
      record.errors.add(attr_name, :end_date, options.merge(:value => value)) if value < 24.hours.from_now
    end
  end
end

module ClientSideValidations::Middleware
  class ValidDate < Base
    def response
      if ((DateTime.parse(request.params[:id].to_s) rescue ArgumentError) == ArgumentError)
        self.status = 404
      else  
        if DateTime.parse(request.params[:id].to_s) > 24.hours.from_now
          self.status = 200
        else
          self.status = 404
        end
      end
      super
    end
  end
end