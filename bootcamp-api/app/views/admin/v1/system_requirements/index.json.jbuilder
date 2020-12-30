json.system_requirements do
	json.array! @loading_service.records , :name, :storage, :memory, :processor, :video_board, :operational_system
end