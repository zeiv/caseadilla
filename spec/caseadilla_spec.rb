require 'spec_helper'

describe Caseadilla do
  it "should have a version" do
    Caseadilla::VERSION.wont_be_nil
  end

  it "should use Rails 4 or greater" do
    Rails::VERSION::MAJOR.must_be :>=, 4
  end
end
