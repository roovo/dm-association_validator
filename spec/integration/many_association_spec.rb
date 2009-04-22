require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "validates_associated for" do

  describe "a VALID association using BASIC association validation", :shared => true do
    
    before(:each) do
        @association_class.validates_present  :name
        @model_class.validates_association    @association_reference

        @associated_model = @association_class.new(:name => "a_name")
        @model            = @model_class.new
        @model.send(@association_reference) << @associated_model
    end

    it "should report the model as valid" do
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
    
    it_should_behave_like "a VALID association using BASIC association validation"
  end
end