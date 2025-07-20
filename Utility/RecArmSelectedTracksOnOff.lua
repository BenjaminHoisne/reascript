-- Number of selected tracks
number_of_tracks = reaper.CountSelectedTracks(0)
-- Total numbers of tracks
total_tracks = reaper.CountTracks(0)
-- Is any tracks armed ? 
any_tracks_armed = false

-- For all tracks, check if it's armed and disarm it. 
for i = 0, total_tracks - 1 do
    track = reaper.GetTrack(0, i)
    if reaper.GetMediaTrackInfo_Value(track, "I_RECARM") == 1 then
        any_tracks_armed = true
        reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 0)
    end
end

-- For selected tracks, arms it. 
if any_tracks_armed == false then 
    for i = 0, number_of_tracks - 1  do
    track = reaper.GetSelectedTrack(0,i)
    reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 1)
end
end
