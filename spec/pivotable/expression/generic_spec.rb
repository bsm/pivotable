require "spec_helper"

describe Pivotable::Expression::Generic do

  def expression(name, opts = {})
    described_class.new Stat, name, opts
  end

  subject do
    expression :date, :via => :period
  end

  it "should build select & group statements" do
    Stat.arel_table.
      project(subject.to_select).
      group(subject.to_group).
      to_sql.clean_sql.should == %(SELECT stats.period AS 'date' FROM stats GROUP BY stats.period)
  end

  it "should use AREL attributes" do
    subject = expression :date, :via => Stat.arel_table[:period]
    Stat.arel_table.project(subject.to_select).to_sql.clean_sql.should == %(SELECT stats.period AS 'date' FROM stats)
  end

end