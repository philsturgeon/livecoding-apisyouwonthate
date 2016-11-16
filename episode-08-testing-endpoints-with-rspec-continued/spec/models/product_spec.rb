require "rails_helper"

RSpec.describe Product do

  it 'requires name and description' do
    expect(subject).to_not be_valid
    subject.name = "Austin"
    expect(subject).to_not be_valid
    subject.description = "We use bittersweet and bittersharp apple varieties."
    expect(subject).to be_valid
  end

end
