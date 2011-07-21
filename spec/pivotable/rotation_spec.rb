require "spec_helper"

describe Pivotable::Rotation do

  subject do
    Stat.pivotable(:by_page)
  end

  describe "by default" do
    subject do
      Page.pivotable :latest do
        maximum :id
        by      :website_id
      end
    end

    it { should_not be_loaded }
    it { should have(:no).selects }
    it { should have(:no).groups  }
    it { should have(:no).joins   }
  end

  it 'should have accessor to model' do
    subject.model.should == Stat
  end

  it 'should have a name' do
    subject.name.should == "by_page"
  end

  it 'can have a parent' do
    subject.parent.should == "base"
  end

  describe "when loaded" do
    before  { subject.load! }

    it { should be_loaded }

    it 'should store definitions' do
      subject.should have(7).selects
      subject.should have(3).groups
      subject.should have(1).join
    end

    it 'should not double-load' do
      2.times { subject.load! }
      subject.should have(7).selects
    end

    it 'should merge with relations and retain scopes' do
      subject.merge(Stat.scoped).should be_a(ActiveRecord::Relation)
      subject.merge(Stat.joins(:date).order(Stat.arel_table[:period])).to_sql.clean_sql.should == %(
        SELECT
          SUM(stats.views) AS views, SUM(stats.visits) AS visits, AVG(stats.bounce_rate) AS bounce_rate, MAX(stats.bounce_rate) AS top_bounce_rate,
          stats.page_id AS page_id, pages.name AS page_name, pages.updated_at AS page_updated_at
        FROM stats
        INNER JOIN periods ON periods.period = stats.period
        INNER JOIN pages ON pages.id = stats.page_id
        GROUP BY stats.page_id, pages.name, pages.updated_at
        ORDER BY stats.period
      ).squish
    end

    it 'should build correct SQL joins' do
      Stat.pivotable(:by_month).merge(Stat.scoped).to_sql.clean_sql.should == %(
        SELECT
          SUM(stats.views) AS views, SUM(stats.visits) AS visits, AVG(stats.bounce_rate) AS bounce_rate,
          periods.month_code AS month_code
        FROM stats
        RIGHT OUTER JOIN periods ON periods.period = stats.period
        GROUP BY periods.month_code
      ).squish
    end



  end
end

