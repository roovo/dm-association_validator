require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Book.belongs_to(:library)" do

  before(:each) do
    Object.send(:remove_const, 'Book')  if Object.const_defined?('Book')
    Object.send(:remove_const, 'Library')  if Object.const_defined?('Library')

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
  end

  describe "with no associated library object" do

    # TODO: remove these eventually as they are just describing normal behaviour
    describe "NOT using association validations" do

      before(:each) do
        @book     = Book.new
      end

      it "should report the book as VALID" do
        @book.should be_valid
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end
    end

    describe "USING association validations" do

      before(:each) do
        Book.validates_association :library

        @book     = Book.new
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end
    end
  end

  describe "with a VALID library" do

    # TODO: remove these eventually as they are just describing normal behaviour
    describe "NOT using association validations" do

      before(:each) do
        Library.validates_present :name

        @library  = Library.new(:name => "British Library")
        @book     = Book.new(:library => @library)
      end

      it "should report the library as VALID" do
        @library.should be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated library after a call to valid?" do
        @book.valid?
        @book.library.errors.size.should == 0
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated library after a call to save" do
        @book.save
        @book.library.errors.size.should == 0
      end

      it "should save the library" do
        @book.save
        Library.all.size.should == 1
      end
    end

    describe "USING association validations" do

      before(:each) do
        Library.validates_present :name
        Book.validates_association :library

        @library  = Library.new(:name => "British Library")
        @book     = Book.new(:library => @library)
      end

      it "should report the library as VALID" do
        @library.should be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated library after a call to valid?" do
        @book.valid?
        @book.library.errors.size.should == 0
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated library after a call to save" do
        @book.save
        @book.library.errors.size.should == 0
      end

      it "should save the library" do
        @book.save
        Library.all.size.should == 1
      end
    end
  end

  describe "with an INVALID library" do

    # TODO: remove these eventually as they are just describing normal behaviour
    describe "NOT using association validations" do

      before(:each) do
        Library.validates_present :name

        @library  = Library.new
        @book     = Book.new(:library => @library)
      end

      it "should report the library as INVALID" do
        @library.should_not be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated library after a call to valid?" do
        @book.valid?
        @book.library.errors.size.should == 0
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end

      it "should have ERRORS on the associated library after a call to save" do
        @book.save
        @book.library.errors.size.should == 1
        @book.library.errors.on(:name).should_not be_nil
      end

      it "should NOT save the (invalid) library" do
        @book.save
        Library.all.size.should == 0
      end
    end

    describe "USING association validations" do

      before(:each) do
        Library.validates_present :name
        Book.validates_association :library

        @library  = Library.new
        @book     = Book.new(:library => @library)
      end

      it "should report the library as INVALID" do
        @library.should_not be_valid
      end

      it "should report the book as INVALID" do
        @book.should_not be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should have ERRORS on the associated library after a call to valid?" do
        @book.valid?
        @book.library.errors.size.should == 1
        @book.library.errors.on(:name).should_not be_nil
      end

      it "should NOT allow the book to be saved" do
        @book.save.should be_false
        Book.all.size.should == 0
      end

      it "should NOT have any ERRORS on the book after a call to save" do
        @book.save
        @book.errors.size.should == 0
      end

      it "should have ERRORS on the associated library after a call to save" do
        @book.save
        @book.library.errors.size.should == 1
        @book.library.errors.on(:name).should_not be_nil
      end

      it "should NOT save the (invalid) library" do
        @book.save
        Library.all.size.should == 0
      end
    end
  end
end
