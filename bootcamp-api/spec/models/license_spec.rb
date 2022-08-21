require 'rails_helper'

RSpec.describe License, type: :model do
  subject { build(:license) }

  it { should validate_presence_of(:key) }
  it { should validate_uniqueness_of(:key) }

  it { should belong_to(:user).optional }
  it { should have_many :games }
end
