require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

# TODO: combine this with the belongs_to spec as it is exactly the same apart fron the models
describe "Book.has_one(:author)" do

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
  end

  describe "with no associated author object" do

    describe "using BASIC association validations" do

      before(:each) do
        Author.validates_present    :name
        Book.validates_association  :author

        @book = Book.new
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end
    end

    describe "using association validations with CONTEXTUAL validations" do

      before(:each) do
        Author.validates_present    :name,      :when         => [:special_reason]
        Book.validates_association  :author,    :with_context => :special_reason

        @book = Book.new
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end
    end
  end

  describe "with a VALID author" do

    describe "using BASIC association validations" do

      before(:each) do
        Author.validates_present    :name
        Book.validates_association  :author

        @author   = Author.new(:name => "Fred Blogs")
        @book     = Book.new(:author => @author)
      end

      it "should report the author as VALID" do
        @author.should be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated author after a call to valid?" do
        @book.valid?
        @book.author.errors.size.should == 0
      end
    end

    describe "using association validations with CONTEXTUAL validations" do

      before(:each) do
        Author.validates_present    :name,      :when         => [:special_reason]
        Book.validates_association  :author,    :with_context => :special_reason

        @author   = Author.new(:name => "Fred Blogs")
        @book     = Book.new(:author => @author)
      end

      it "should report the author as VALID" do
        @author.should be_valid
      end

      it "should report the book as VALID" do
        @book.should be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should NOT have any ERRORS on the associated author after a call to valid?" do
        @book.valid?
        @book.author.errors.size.should == 0
      end
    end
  end

  describe "with an INVALID author" do

    describe "using BASIC association validations" do

      before(:each) do
        Author.validates_present    :name
        Book.validates_association  :author

        @author   = Author.new
        @book     = Book.new(:author => @author)
      end

      it "should report the author as INVALID" do
        @author.should_not be_valid
      end

      it "should report the book as INVALID" do
        @book.should_not be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should have ERRORS on the associated author after a call to valid?" do
        @book.valid?
        @book.author.errors.size.should == 1
        @book.author.errors.on(:name).should_not be_nil
      end
    end

    describe "using association validations with CONTEXTUAL validations" do

      before(:each) do
        Author.validates_present    :name,      :when         => [:special_reason]
        Book.validates_association  :author,    :with_context => :special_reason

        @author   = Author.new
        @book     = Book.new(:author => @author)
      end

      it "should report the author as VALID for the :default context" do
        @author.should be_valid
      end

      it "should report the author as INVALID for the specified (:special_reason) context" do
        @author.should_not be_valid_for_special_reason
      end

      it "should report the book as INVALID" do
        @book.should_not be_valid
      end

      it "should NOT have any ERRORS on the book after a call to valid?" do
        @book.valid?
        @book.errors.size.should == 0
      end

      it "should have ERRORS on the associated author after a call to valid?" do
        @book.valid?
        @book.author.errors.size.should == 1
        @book.author.errors.on(:name).should_not be_nil
      end
    end
  end
end
