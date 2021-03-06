require 'spec_helper'

describe "rails_zero:generate" do
  include_context "rake"
  
  its(:prerequisites) { should include("environment") }

  it "generates the site" do
    expect_any_instance_of(RailsZero::GenerateSiteJob).to receive(:run).with()
    subject.invoke
  end
end

describe "rails_zero:deploy:prepare" do
  include_context "rake"

  its(:prerequisites) { should include("environment") }

  it "downloads with packages client" do
    expect_any_instance_of(RailsZero::PackagesClient).to receive(:get).with()
    subject.invoke
  end
end

describe "rails_zero:deploy:git" do
  include_context "rake"

  its(:prerequisites) { should include("prepare") }

  it "deploys to a git remote" do
    expect_any_instance_of(RailsZero::GitDeployer).to receive(:run).with()
    subject.invoke
  end
end
