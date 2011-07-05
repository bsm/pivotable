require "spec_helper"

describe Pivotable::Collection do

  subject do
    described_class.new(Website)
  end

  it { should be_a(Hash) }

  it 'should define and store rotations' do
    subject.rotation :latest do
      maximum :id
    end
    subject.keys.should == [:latest]
    subject[:latest].should be_instance_of(Pivotable::Rotation)
  end

end