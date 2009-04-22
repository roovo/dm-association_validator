require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "validates_associated for" do

  describe "a valid main and associated model", :shared => true do

    it "should report the main model as VALID" do
      @model.should be_valid
    end

    it "should NOT have any ERRORS on the main model after a call to valid?" do
      @model.valid?
      @model.errors.size.should == 0
    end

    it "should NOT have any ERRORS on the associated model after a call to valid?" do
      @model.valid?
      @model.send(@association_reference).errors.size.should == 0
    end
  end

  describe "a valid main model with an invalid associated model", :shared => true do

    it "should report the main model as INVALID" do
      @model.should_not be_valid
    end

    it "should NOT have any ERRORS on the main model after a call to valid?" do
      @model.valid?
      @model.errors.size.should == 0
    end

    it "should have ERRORS on the associated model after a call to valid?" do
      @model.valid?
      @model.send(@association_reference).errors.size.should == 1
      @model.send(@association_reference).errors.on(:name).should_not be_nil
    end
  end

  describe "a VALID association using BASIC association validations", :shared => true do

    describe "with a VALID associated model using the BASIC association validations" do

      before(:each) do
        @association_class.validates_present  :name
        @model_class.validates_association    @association_reference

        @associated_model = @association_class.new(:name => "a_name")
        @model            = @model_class.new(@association_reference => @associated_model)
      end

      it_should_behave_like "a valid main and associated model"
    end
  end

  describe "a VALID association using CONTEXTUAL association validations", :shared => true do

    describe "with a VALID associated model using CONTEXTUAL association validations" do
      before(:each) do
        @association_class.validates_present  :name,                    :when         => [:special_reason]
        @model_class.validates_association    @association_reference,   :with_context => :special_reason

        @associated_model = @association_class.new(:name => "a_name")
        @model            = @model_class.new(@association_reference => @associated_model)
      end

      it_should_behave_like "a valid main and associated model"
    end
  end

  describe "an INVALID association using BASIC association validations", :shared => true do

    describe "with an INVALID associated model using the BASIC association validations" do

      before(:each) do
        @association_class.validates_present  :name
        @model_class.validates_association    @association_reference

        @associated_model = @association_class.new
        @model            = @model_class.new(@association_reference => @associated_model)
      end

      it_should_behave_like "a valid main model with an invalid associated model"
    end
  end

  describe "an INVALID association using CONTEXTUAL association validations", :shared => true do

    describe "with an INVALID associated model using CONTEXTUAL association validations" do

      before(:each) do
        @association_class.validates_present  :name,                    :when         => [:special_reason]
        @model_class.validates_association    @association_reference,   :with_context => :special_reason

        @associated_model = @association_class.new
        @model            = @model_class.new(@association_reference => @associated_model)
      end

      it_should_behave_like "a valid main model with an invalid associated model"
    end
  end

  describe "Book.belongs_to(:library)" do

    before(:each) do
      Object.send(:remove_const, 'Book')      if Object.const_defined?('Book')
      Object.send(:remove_const, 'Library')   if Object.const_defined?('Library')

      class Book
        include DataMapper::Resource

        property :id,      Serial
        property :title,   String

        belongs_to :library
      end

      class Library
        include DataMapper::Resource

        property :id,         Serial
        property :name,       String

        has n, :books
      end

      DataMapper.auto_migrate!
      
      @model_class            = Book
      @association_class      = Library
      @association_reference  = :library
    end

    it_should_behave_like "a VALID association using BASIC association validations"
    it_should_behave_like "a VALID association using CONTEXTUAL association validations"
    it_should_behave_like "an INVALID association using BASIC association validations"
    it_should_behave_like "an INVALID association using CONTEXTUAL association validations"
  end

  describe "Book.has 1, :author" do

    before(:each) do
      Object.send(:remove_const, 'Book')    if Object.const_defined?('Book')
      Object.send(:remove_const, 'Author')  if Object.const_defined?('Author')

      class Book
        include DataMapper::Resource

        property :id,      Serial
        property :title,   String

        has 1, :author
      end

      class Author
        include DataMapper::Resource

        property :id,         Serial
        property :name,       String

        belongs_to :book        # a bit crass I know....
      end

      DataMapper.auto_migrate!
      
      @model_class            = Book
      @association_class      = Author
      @association_reference  = :author
    end

    it_should_behave_like "a VALID association using BASIC association validations"
    it_should_behave_like "a VALID association using CONTEXTUAL association validations"
    it_should_behave_like "an INVALID association using BASIC association validations"
    it_should_behave_like "an INVALID association using CONTEXTUAL association validations"
  end
end
