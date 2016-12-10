require "spec_helper"

describe Resquire, "describe version and banner constant information" do
  it "has a version number" do
    expect(Resquire::VERSION).not_to be nil
  end
  
  it "has a version number" do
    expect(Resquire::BANNER).not_to be nil
  end
end

