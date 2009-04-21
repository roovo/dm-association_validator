module DataMapper
  module Validate

    class AssociationValidator < GenericValidator

      def initialize(field_name, options = {})
        super
        @field_name, @options = field_name, options
      end

      def call(target)
        association = target.validation_property_value(field_name)
        return true if association.nil?

        target_context = @options[:with_context] || :default

        return true if association.valid?(target_context)

        false
      end
    end

    module ValidatesAssociation

      def validates_association(*fields)
        opts = opts_from_validator_args(fields)
        add_validator_to_context(opts, fields, DataMapper::Validate::AssociationValidator)
      end
    end
  end
end
