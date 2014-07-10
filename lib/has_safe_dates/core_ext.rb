require 'chronic'

module HasSafeDates

  module CoreExt
    extend ActiveSupport::Concern

    module ClassMethods
      def has_safe_fields_config
        @@has_safe_fields_config ||= {}
      end

      def has_safe_dates(*args)
        options = args.extract_options!
        has_safe_fields_config[self] = options

        if options[:error_message].present?
          has_safe_fields_config[self][:error_message] = options[:error_message]
        else
          has_safe_fields_config[self][:error_message] = I18n.translate('activerecord.errors.messages')[:invalid] || 'is invalid'
        end

        if args.blank?
          raise ArgumentError, 'Must define the fields you want to be converted to safe dates with "has_safe_dates :my_field_name_date, :my_other_field_name_date"'
        end
        has_safe_fields_config[self][:fields] = args.map(&:to_s)

        has_safe_fields_config[self][:fields].each do |field|
          define_method "#{field.to_s}=" do |value|
            if value.present?
              value = Chronic.parse(value.to_s)
              if value.blank? && self.class.has_safe_fields_config[self.class][:error_message].present?
                @safe_date_validation_errors ||= {}
                @safe_date_validation_errors[field] = self.class.has_safe_fields_config[self.class][:error_message]
              end
            end
            super value
          end
        end

        define_method "_set_safe_date_validation_errors" do
          if @safe_date_validation_errors.present?
            @safe_date_validation_errors.each_pair do |field, error|
              errors.add(field, error)
            end
          end
          @safe_date_validation_errors = nil
        end

        class_eval do
          validate :_set_safe_date_validation_errors
        end
      end
    end
  end

  module MultiparameterAttributeExt
    # Overrides #read_date when has_safe_dates is enabled for the current field the multiparameter.
    # Otherwise the original #read_date method is invoked.
    def read_date
      if ActiveRecord::Base.has_safe_fields_config[object.class] && ActiveRecord::Base.has_safe_fields_config[object.class][:fields].include?(name)
        values.values_at(1,2,3).join("-")  # Convert multiparameter parts into a Date string, e.g. "2011-4-23", return it, and allow CoreExt methods handle the result.
      else
        super  # has_safe_dates is not enabled for the current field, so invoke the super method (original #read_date method).
      end
    end
  end
end

ActiveRecord::Base.send :include, HasSafeDates::CoreExt
ActiveRecord::AttributeAssignment::MultiparameterAttribute.send :prepend, HasSafeDates::MultiparameterAttributeExt
