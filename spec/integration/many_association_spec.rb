require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "validates_associated for" do

  describe "a valid main and associated model for many associations", :shared => true do

    it "should report the main model as VALID" do
      @model.should be_valid
    end

    it "should NOT have any ERRORS on the main model after a call to valid?" do
      @model.valid?
      @model.errors.size.should == 0
    end

    it "should NOT have any ERRORS on the associated model after a call to valid?" do
      @model.valid?
      @model.send(@association_reference).first.errors.size.should == 0
    end
  end

  describe "a valid main model with an invalid associated model for many associations", :shared => true do

    it "should report the main model as INVALID" do
      @model.should_not be_valid
    end

    it "should NOT have any ERRORS on the main model after a call to valid?" do
      @model.valid?
      @model.errors.size.should == 0
    end

    it "should have ERRORS on the associated model after a call to valid?" do
      @model.valid?
      @model.send(@association_reference).first.errors.size.should == 1
      @model.send(@association_reference).first.errors.on(:name).should_not be_nil
    end
  end

  describe "a VALID association using BASIC association validation for many associations", :shared => true do
    
    describe "with a VALID associated model using the BASIC association validations" do
      before(:each) do
        @association_class.validates_present  :name
        @model_class.validates_association    @association_reference

        @associated_model = @association_class.new(:name => "a_name")
        @model            = @model_class.new
        @model.send(@association_reference) << @associated_model
      end

      it_should_behave_like "a valid main and associated model for many associations"
    end
  end

  describe "a VALID association using CONTEXTUAL association validation for many associations", :shared => true do
    
    describe "with a VALID associated model using the CONTEXTUAL association validations" do
      before(:each) do
        @association_class.validates_present  :name,                    :when         => [:special_reason]
        @model_class.validates_association    @association_reference,   :with_context => :special_reason

        @associated_model = @association_class.new(:name => "a_name")
        @model            = @model_class.new
        @model.send(@association_reference) << @associated_model
      end

      it_should_behave_like "a valid main and associated model for many associations"
    end
  end

  describe "an INVALID association using BASIC association validations for many associations", :shared => true do

    describe "with an INVALID associated model using the BASIC association validations" do

      before(:each) do
        @association_class.validates_present  :name
        @model_class.validates_association    @association_reference

        @associated_model = @association_class.new
        @model            = @model_class.new
        @model.send(@association_reference) << @associated_model
      end

      it_should_behave_like "a valid main model with an invalid associated model for many associations"
    end
  end

  describe "an INVALID association using CONTEXTUAL association validations for many associations", :shared => true do

    describe "with an INVALID associated model using CONTEXTUAL association validations" do

      before(:each) do
        @association_class.validates_present  :name,                    :when         => [:special_reason]
        @model_class.validates_association    @association_reference,   :with_context => :special_reason

        @associated_model = @association_class.new
        @model            = @model_class.new
        @model.send(@association_reference) << @associated_model
      end

      it_should_behave_like "a valid main model with an invalid associated model for many associations"
    end
  end

  describe "Library.has n, :books" do

    before(:each) do
      Object.send(:remove_const, 'Book')      if Object.const_defined?('Book')
      Object.send(:remove_const, 'Library')   if Object.const_defined?('Library')

      class Book
        include DataMapper::Resource

        property :id,      Serial
        property :name,    String

        belongs_to :library
      end

      class Library
        include DataMapper::Resource

        property :id,         Serial
        property :name,       String

        has n, :books
      end

      DataMapper.auto_migrate!
      
      @model_class            = Library
      @association_class      = Book
      @association_reference  = :books
    end
    
    it_should_behave_like "a VALID association using BASIC association validation for many associations"
    it_should_behave_like "a VALID association using CONTEXTUAL association validation for many associations"
    it_should_behave_like "an INVALID association using BASIC association validations for many associations"
    it_should_behave_like "an INVALID association using CONTEXTUAL association validations for many associations"
  end
end
