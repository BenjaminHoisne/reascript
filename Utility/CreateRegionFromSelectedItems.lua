-- Start undo action
reaper.Undo_BeginBlock()

-- Count for each combination of tracks + folder tracks 
local counters = {}

-- Number of selected items
local item_count = reaper.CountSelectedMediaItems(0)

for i = 0, item_count - 1 do
  local item = reaper.GetSelectedMediaItem(0, i)
  local track = reaper.GetMediaItemTrack(item)

  -- Name of the track
  local _, track_name = reaper.GetTrackName(track)

  -- Name of the folder track
  local folder_track = reaper.GetParentTrack(track)
  local folder_name = "NoFolder"
  if folder_track ~= nil then
    _, folder_name = reaper.GetTrackName(folder_track)
  end

  -- Group identification key
  local key = folder_name .. "___" .. track_name

  -- Initialize or increment counter
  if counters[key] == nil then
    counters[key] = 1
  else
    counters[key] = counters[key] + 1
  end

  -- Get position and duration of the item
  local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

  -- Create region name
  local region_name = string.format("SW_%s_%s_%02d", folder_name, track_name, counters[key])

  -- Create region
  reaper.AddProjectMarker2(0, true, pos, pos + len, region_name, -1, 0)
end

-- End of undo action
reaper.Undo_EndBlock("Créer régions avec numéros de variation par groupe Folder/Track", -1)

