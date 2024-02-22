module FactoryHelpers
  def self.upload_file(src, content_type, binary = false)
    path = Rails.root.join(src)
    original_filename = ::File.basename(path)

    content = File.open(path).read
    tempfile = Tempfile.open(original_filename)
    tempfile.write content
    tempfile.rewind

    uploaded_file = Rack::Test::UploadedFile.new(tempfile, content_type, binary, original_filename: original_filename)

    ObjectSpace.define_finalizer(uploaded_file, uploaded_file.class.finalize(tempfile))

    uploaded_file
  end
end

if Rails.env.development? || Rails.env.test?
	require 'factory_bot'
  # FactoryBot.definition_file_paths = Dir[Rails.root.join('spec', 'factories', '**', '*.rb')].sort.each { |f| require f }

	namespace :dev do
		desc 'Sample data for local development environment'
		task prime: 'db:setup' do
			include FactoryBot::Syntax::Methods

			15.times do
				profile = [:admin, :client].sample
				create(:user, profile: profile)
			end

			system_requirements = []
			['Basic', 'Intermediate', 'Advanced'].each do |sr_name|
				system_requirements << create(:system_requirement, name: sr_name)
			end

			15.times do
				coupon_status = [:active, :inactive].sample
				create(:coupon, status: coupon_status)
			end

			categories = []
			25.times do
				categories << create(:category, name: Faker::Game.unique.genre)
			end

			30.times do
				game_name = Faker::Game.unique.title
				availability = [:available, :unavailable].sample
				categories_count = rand(0..3)
				game_categories_ids = []
				categories_count.times { game_categories_ids << Category.all.sample.id }
				game = create(:game, system_requirement: system_requirements.sample)
				# create(:product, name: game_name, status: availability, category_ids: game_categories_ids, productable: game)
			end

			puts "Database was persisted"
		end
	end
end
