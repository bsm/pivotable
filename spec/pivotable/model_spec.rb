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
    subject.pivotable { res = self.class.name }
    subject._pivotable.keys.should == [:_default]
    res.should == "Pivotable::Collection"
  end

  it 'should allow to define custom rotations' do
    subject.pivotable("custom") { }
    subject._pivotable.keys.should =~ [:_default, :custom]
  end

  it 'should allow to retrieve rotations without definition' do
    subject.pivotable.should be_a(Pivotable::Collection)
  end

  it 'should delegate pivot operations to scoped relation' do
    subject.pivotable { rotation(:max_id) {} }
    subject.pivot(:max_id).class.should == ActiveRecord::Relation
  end

end

