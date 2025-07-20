number_of_tracks = reaper.CountSelectedTracks(0)
total_tracks = reaper.CountTracks(0)
any_tracks_armed = false
for i = 0, total_tracks - 1 do
    track = reaper.GetTrack(0, i)
    if reaper.GetMediaTrackInfo_Value(track, "I_RECARM") == 1 then
        any_tracks_armed = true
        reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 0)
    end
end
if any_tracks_armed == false then 
    for i = 0, number_of_tracks - 1  do
    -- body
    track = reaper.GetSelectedTrack(0,i)
    reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 1)
end
end