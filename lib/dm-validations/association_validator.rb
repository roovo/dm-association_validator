module DataMapper
  module Validate

    class AssociationValidator < GenericValidator #:nodoc:

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

      # Allows finer controlled validation of associated models than offered by
      # the all_valid? method.
      #
      # You can use the standard contextual and conditional options :when :if and :unless
      # to control when the associations should be validated.
      #
      # You can use the :with_context option to control the context that the associated
      # model should be validated with. If this option is not provided the associated
      # model will be validated in the default context.
      #
      # ===example [Usage]
      #   require dm-association_validator
      #
      #   class User
      #     include DataMapper::Resource
      #
      #     property :id, Serial
      #
      #     has_many  :subscriptions
      #     has_one   :email_address
      #
      #     validates_association :subscriptions,     :when         => [:renewing, :joining]
      #     validates_association :subscriptions,     :when         => [:admin_entering],
      #                                               :with_context => :admin_entering
      #     validates_association :email_address,     :unless       => Proc.new { |u| u.email_address.blank? },
      #                                               :when         => [:default, :renewing, :joining, :admin_entering]
      #     
      #   end
      #
      # This will validate the subscriptions if the user's validation context is one of
      # :renewing, :joining, or :admin_entering.  In the case of :renewing and :joining
      # the subscriptions will be validated using the :default context.  In the case of
      # :admin_entering they will be validated in the :admin_entering context.
      #
      # The email address will be validated for for all the contexts above as well as the
      # :default context, but only if the associated model says it's not blank.
      def validates_association(*fields)
        opts = opts_from_validator_args(fields)
        add_validator_to_context(opts, fields, DataMapper::Validate::AssociationValidator)
      end
    end
  end
end
