require "spec_helper"

describe Pivotable::Pivoting do
  fixtures :all

  let :relation do
    Stat.send(:relation)
  end

  it 'should be includable' do
    relation.should respond_to(:pivot)
  end

  it 'should apply pivots relations' do
    relation.pivot(:by_day).should be_a(ActiveRecord::Relation)
    relation.pivot(:by_day).to_a.should have(3).items
  end

end

