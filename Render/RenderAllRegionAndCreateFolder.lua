-- Script : Render all regions and create a folder based on the region name. 
-- Author : Benjamin Hoisne
-- Date   : 2023-10-20
-- Version: 1.0

local default_path = reaper.GetProjectPath("")
local retval, input = reaper.GetUserInputs(
    "Paramètres d'export",
    4,
    "Chemin dossier,Sample rate,Bit depth,Canaux (1=Mono,2=Stéréo)",
    default_path .. ",48000,24,2"
)
if not retval then return end

local export_path, sample_rate, bit_depth, channels = input:match("([^,]+),([^,]+),([^,]+),([^,]+)")
if not (export_path and sample_rate and bit_depth and channels) then
    reaper.ShowMessageBox("Entrée invalide. Veuillez remplir tous les champs.", "Erreur", 0)
    return
end

-- Fonction utilitaire pour créer un dossier si besoin
local function ensure_folder(path)
    os.execute('mkdir "' .. path .. '"')
end

-- Récupère le nombre de régions
local marker_count, region_count = reaper.CountProjectMarkers(0)
local total_count = marker_count + region_count

for i = 0, total_count - 1 do
    local retval, is_region, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if is_region then
        local track = nil
        local track_name = "NoTrack"
        local folder_name = "NoFolder"
        local track_count = reaper.CountTracks(0)
        for t = 0, track_count - 1 do
            local tr = reaper.GetTrack(0, t)
            -- Vérifie si la piste a du contenu dans la région
            local item_count = reaper.CountTrackMediaItems(tr)
            for it = 0, item_count - 1 do
                local item = reaper.GetTrackMediaItem(tr, it)
                local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                local item_end = item_pos + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                if item_pos < rgnend and item_end > pos then
                    track = tr
                    local _, tn = reaper.GetTrackName(track, "")
                    track_name = tn or "NoTrack"
                    local parent_track = reaper.GetParentTrack(track)
                    if parent_track then
                        local _, fn = reaper.GetTrackName(parent_track, "")
                        folder_name = fn or "NoFolder"
                    end
                    break
                end
            end
            if track then break end
        end

        -- Crée le dossier d'export
        local region_folder = export_path .. "/" .. folder_name .. "/" .. track_name
        ensure_folder(region_folder)

        -- Définit le chemin de rendu
        local render_path = region_folder .. "/" .. name .. ".wav"
        reaper.GetSetProjectInfo_String(0, "RENDER_FILE", render_path, true)

        -- Sélectionne la région
        reaper.GetSet_LoopTimeRange(true, false, pos, rgnend, false)

        -- Désactive le mode "render all regions" et active "render time selection only"
        reaper.GetSetProjectInfo(0, "I_RENDER_REGIONS", 0, true) -- 0 = no region render
        reaper.GetSetProjectInfo(0, "I_RENDER_LIMSEL", 1, true)  -- 1 = render time selection only

        reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", true)

        -- Lance le rendu
        reaper.Main_OnCommand(41824, 0)

        -- Réinitialise la sélection temporelle
        reaper.GetSet_LoopTimeRange(true, false, 0, 0, false)
    end
end