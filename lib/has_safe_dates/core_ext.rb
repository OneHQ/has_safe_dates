require 'chronic'

module HasSafeDates

  module CoreExt
    extend ActiveSupport::Concern

    module ClassMethods

      def has_safe_fields_config
        @has_safe_fields_config ||= {}
      end

      def has_safe_dates(*args)
        options = args.extract_options!

        if options[:error_message].present?
          has_safe_fields_config[:error_message] = options[:error_message]
        else
          has_safe_fields_config[:error_message] = I18n.translate('activerecord.errors.messages')[:invalid] || 'is invalid'
        end

        if args.blank?
          raise ArgumentError, 'Must define the fields you want to be converted to safe dates with "has_safe_dates :my_field_name_date, :my_other_field_name_date"'
        end
        has_safe_fields_config[:fields] = args.map(&:to_s)
        has_safe_fields_config[:fields].each do |field|
          define_method "#{field.to_s}=" do |value|
            if value.present?
              value = Chronic.parse(value.to_s)
              self.errors.add(field, self.class.has_safe_fields_config[:error_message]) unless value.present?
            end
            super value
          end
        end
      end
    end

    def read_value_from_parameter(name, values_hash_from_param)
      if self.class.has_safe_fields_config[:fields].include?(name.to_s)

        max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param, 6)
        return nil if (1..3).any? {|position| values_hash_from_param[position].blank?}
        set_values = (1..max_position).collect{|position| values_hash_from_param[position] }

        date = set_values[0..2].join('-')
        time = set_values[3..5].join(':')
        value = Chronic.parse("#{date} #{time}")

        return value
      else
        super name, values_hash_from_param
      end
    end

  end
end
 
ActiveRecord::Base.send :include, HasSafeDates::CoreExt
