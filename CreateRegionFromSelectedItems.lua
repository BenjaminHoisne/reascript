-- Commencer une action Undo
reaper.Undo_BeginBlock()

-- Table de compteurs pour chaque combinaison Folder+Track
local counters = {}

-- Nombre d'items sélectionnés
local item_count = reaper.CountSelectedMediaItems(0)

for i = 0, item_count - 1 do
  local item = reaper.GetSelectedMediaItem(0, i)
  local track = reaper.GetMediaItemTrack(item)

  -- Nom de la piste
  local _, track_name = reaper.GetTrackName(track)

  -- Nom du dossier parent (folder)
  local folder_track = reaper.GetParentTrack(track)
  local folder_name = "NoFolder"
  if folder_track ~= nil then
    _, folder_name = reaper.GetTrackName(folder_track)
  end

  -- Clé d’identification du groupe
  local key = folder_name .. "___" .. track_name

  -- Initialiser ou incrémenter le compteur
  if counters[key] == nil then
    counters[key] = 1
  else
    counters[key] = counters[key] + 1
  end

  -- Récupérer position et durée de l’item
  local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

  -- Créer le nom de la région
  local region_name = string.format("SW_%s_%s_%02d", folder_name, track_name, counters[key])

  -- Créer la région
  reaper.AddProjectMarker2(0, true, pos, pos + len, region_name, -1, 0)
end

-- Fin de l’action Undo
reaper.Undo_EndBlock("Créer régions avec numéros de variation par groupe Folder/Track", -1)

