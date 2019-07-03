# frozen_string_literal: true

require "chronic"

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
          has_safe_fields_config[self][:error_message] = I18n.translate("activerecord.errors.messages")[:invalid] || "is invalid"
        end

        if args.blank?
          raise ArgumentError, 'Must define the fields you want to be converted to safe dates with "has_safe_dates :my_field_name_date, :my_other_field_name_date"'
        end
        has_safe_fields_config[self][:fields] = args.map(&:to_s)

        has_safe_fields_config[self][:fields].each do |field|
          define_method "#{field}=" do |value|
            if value.present?
              value = Chronic.parse(value.to_s)
              if value.blank? && self.class.has_safe_fields_config[self.class.base_class][:error_message].present?
                @safe_date_validation_errors ||= {}
                @safe_date_validation_errors[field] = self.class.has_safe_fields_config[self.class.base_class][:error_message]
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

  module DateTimeExt
    def execute_callstack_for_multiparameter_attributes(callstack)
      if ::ActiveRecord::Base.has_safe_fields_config[self.class.base_class]
        callstack.each do |name, values_with_empty_parameters|
          if ActiveRecord::Base.has_safe_fields_config[self.class.base_class][:fields].include?(name)
            date = values_with_empty_parameters.values_at(1, 2, 3).join("-")
            time = values_with_empty_parameters.values_at(4, 5).join(":")
            datetime_string = "#{date}#{time.blank? ? "" : " #{time}"}"

            # Convert multiparameter parts into a Date string, e.g. "2011-4-23",
            # and pass it through so that CoreExt methods handle the result.
            send("#{name}=", datetime_string)
          else
            super({ name => values_with_empty_parameters })
          end
        end
      else
        super(callstack)  # has_safe_dates is not enabled for the current field, so invoke the super method
      end
    end
  end
end

::ActiveRecord::Base.send :include, ::HasSafeDates::CoreExt
::ActiveRecord::Base.send :prepend, ::HasSafeDates::DateTimeExt
