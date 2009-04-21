require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Book.belongs_to(:library)" do

  describe "with an INVALID library" do

    describe "and NOT using association validations" do

      before(:each) do
        DataMapper.auto_migrate!
        Library.validates_present :name

        @library  = Library.new
        @book     = Book.new(:library => @library)
      end

      it "should report the library as INVALID" do
        @library.should_not be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT save the (invalid) library" do
        @book.save.should be_true
        Library.all.size.should == 0
      end
    end

    describe "and USING association validations" do

      before(:each) do
        DataMapper.auto_migrate!
        Library.validates_present :name
        Book.validates_associated :library

        @library  = Library.new
        @book     = Book.new(:library => @library)
      end

      it "should report the library as INVALID" do
        @library.should_not be_valid
      end

      it "should report the book as INVALID" do
        @book.should be_valid
      end

      it "should NOT allow the book to be saved" do
        @book.save.should be_true
        Book.all.size.should == 1
      end

      it "should NOT save the (invalid) library" do
        @book.save.should be_true
        Library.all.size.should == 0
      end
    end
  end
end
