require "spec_helper"

describe Pivotable::Expression::Calculation do

  def expression(name, opts = {})
    described_class.new Stat, name, opts
  end

  subject do
    expression :views, :function => :sum
  end

  it "should should require a function" do
    lambda { expression :views }.should raise_error(ArgumentError)
  end

  it "should should require a valid function" do
    lambda { expression :views, :function => :lower }.should raise_error(NoMethodError)
  end

  it "should build select statements from function symbols" do
    subject.to_select.should be_a(Arel::Expression)
    subject.to_select.to_sql.clean_sql.should == %(SUM(stats.views) AS 'views')
  end

  it "should not build group statements" do
    lambda { subject.to_group }.should raise_error(RuntimeError)
  end

  it "should build selects from SQL statements" do
    subject = expression :total_views, :via => "SUM(views)"
    subject.via.should == "SUM(views)"
    subject.to_select.should == %(SUM(views) AS 'total_views')
  end

  it "should build selects from AREL expressions" do
    subject = expression :average_views, :via => Stat.arel_table[:views].average
    subject.via.should be_a(Arel::Expression)
    subject.to_select.to_sql.clean_sql.should == %(AVG(stats.views) AS 'average_views')
  end

end