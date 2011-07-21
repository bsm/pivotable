require "spec_helper"

describe Pivotable::Expression::Abstract do

  def expression(col, opts = {})
    described_class.new Stat, col, opts
  end

  subject do
    expression :views
  end

  it { should respond_to(:to_select) }
  it { should respond_to(:to_group) }

  it "should be abstract" do
    lambda { subject.to_select }.should raise_error(NotImplementedError)
    lambda { subject.to_group }.should raise_error(NotImplementedError)
  end

  it "should have a name" do
    subject.name.should == "views"
  end

  it "should have a model" do
    subject.model.should == Stat
  end

  it "should have a via attribute" do
    subject.via.should be_a(Arel::Attribute)
  end

  it "should require via attribute" do
    lambda { expression :bogus }.should raise_error(ArgumentError)
  end

  it "should work via SQL statements" do
    subject = expression :views, :via => "SUM(views)"
    subject.via.should be_a(String)
    subject.via.should == "SUM(views)"
  end

  it "should work via column symbols" do
    subject = expression :my_views, :via => :views
    subject.via.should be_a(Arel::Attribute)
    subject.via.name.should == :views
  end

  it "should work via name only" do
    subject.via.should be_a(Arel::Attribute)
    subject.via.name.should == :views
  end

end