json.system_requirements do
	json.array! @system_requirements , :name, :storage, :memory, :processor, :video_board, :operational_system
end