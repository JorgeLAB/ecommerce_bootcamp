RSpec.describe SystemRequirement, type: :model do
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:storage) }
	it { should validate_presence_of(:memory) }
	it { should validate_presence_of(:video_board) }
	it { should validate_presence_of(:operational_system) }
	it { should validate_presence_of(:processor) }

	it_behaves_like "name searchable concern", :system_requirement
	it_behaves_like "paginatable concern", :system_requirement

end
