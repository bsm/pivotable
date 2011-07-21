require "spec_helper"

describe Pivotable do

  it 'should generate names' do
    described_class.name(:a).should == "a"
    described_class.name('a').should == "a"
    described_class.name(:a, :b, " c").should == "a:b:c"
    described_class.name([:a], [:b, " c"]).should == "a:b:c"
    described_class.name("").should be_nil
    described_class.name(nil).should be_nil
  end

end

