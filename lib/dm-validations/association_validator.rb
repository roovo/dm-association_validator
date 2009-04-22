module DataMapper
  module Validate

    class AssociationValidator < GenericValidator

      def initialize(field_name, options = {})
        super
        @field_name, @options = field_name, options
      end

      def call(target)
        association       = target.validation_property_value(field_name)
        associated_models = case association
                            when nil
                              return true
                            when DataMapper::Associations::OneToMany::Proxy, DataMapper::Associations::ManyToMany::Proxy
                              association
                            else
                              [association]
                            end

        target_context = @options[:with_context] || :default

        associations_valid = true
        associated_models.each do |associated_model|
          next if associated_model.nil?
          associations_valid = false unless associated_model.valid?(target_context)
        end
        associations_valid
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
