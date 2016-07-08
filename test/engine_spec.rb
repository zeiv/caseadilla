require 'spec_helper'

describe Caseadilla::Engine do
  it 'should be flavorful' do
    Caseadilla::Engine.flavor.wont_be_nil
  end
end
