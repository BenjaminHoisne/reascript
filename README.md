# ReaScripts

A small collection of ReaScripts to improve workflows in Reaper.  

## Utilities

### CreateRegionFromSelectedItems

- **Purpose**: Automatically creates regions from selected items in the timeline.
- **Naming convention**:  
  By default: `SW_FolderTrackName_TrackName_VariationNumber`  
  The user can choose a custom prefix instead of `"SW_"`.
- **Use case**: Organize variations quickly for game audio exports in Unreal Engine.

## Rendering

### RenderAllRegionMasterMix

- **Purpose**: Adds all existing regions to the render matrix (Master Mix), and opens the render window automatically.
- **Use case**: Simplifies the process of batch rendering all defined regions in one click, without manually configuring the matrix.
