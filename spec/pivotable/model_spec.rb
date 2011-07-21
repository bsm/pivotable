require "spec_helper"

describe Pivotable::Model do

  subject do
    Class.new(ActiveRecord::Base)
  end

  it 'should be includable' do
    subject.send(:included_modules).should include(described_class)
  end

  it 'should allow to define rotations' do
    res = nil
    subject._pivotable.should be_a(Hash)
    subject.pivotable(:random) { res = self.class.name }.load!
    subject._pivotable.keys.should == ["random"]
    res.should == "Pivotable::Rotation"
  end

  it 'should allow to define custom rotations with parents' do
    subject.pivotable(:parent) { }
    subject.pivotable(:custom => :parent) { }
    subject._pivotable.keys.should =~ ["parent", "custom"]
    subject.pivotable(:custom).parent.should == "parent"
    subject.pivotable(:custom).name.should == "custom"
  end

  it 'should allow scoped notations' do
    subject.pivotable(:admin, :base) { }
    subject.pivotable("admin:plus" => "admin:base") { }
    subject.pivotable(:admin, :custom => [:admin, :base]) { }

    subject.pivotable([:admin, :plus]).parent.should == "admin:base"
    subject.pivotable("admin:custom").parent.should == "admin:base"
  end

  it 'should delegate pivot operations to scoped relation' do
    subject.pivotable(:max_id) { }
    subject.pivot(:max_id).class.should == ActiveRecord::Relation
  end

end

