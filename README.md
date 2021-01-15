# AseemViewer
Viewer for Aseem logs written in processing.

## Startup

Create `data` folder in repo's directory.

### Create new project:
- set `proj_name` variable in `viewer4.pde` to name of project
- add `fmLog.log`(don't change name of the file) file to `data` folder 
- run sketch

### Start existing project:
- set `proj_name` variable in `viewer4.pde` to name of project one wants to start
- run sketch

## Usage

| Shortcut | Description|
| --- | --- |
| `drag mouse` | move the map around |
| `-` / `+` | zoom in/out |
| `space` | (un)pause |
| `[` / `]` | speed up/down (negative speed is possible - plays the simulation in reverse) |
|  `RIGHT` (`LEFT`)| jump forward (backwards) 10s (simulated seconds not real) |
|`UP` (`DOWN`) | jump forward (backwards) 1min (simulated minute not real) |
| `1`, `2`, `3` | show/hide states: `AVALIABLE`, `ASSIGNED`, `EN ROUTE`| 
| `e` | trigger destination edges (renders slow if all vehicles are visible) |
| `mouse click` | (un)highlight a vehicle (only at zoom <= 5) |
| `h` | wait for vehicle id from keyboard and set it as the selected/highlighted one. `ENTER` to finish |
| `t` | (un)triger rendering trail for selected vehicle |
| `f` | (un) trigger following the selected vehicle |
| `r` | stops/starts rendering, (pause with space still renders, just doesn't change the time) |

## Different map

At this point viewer loads manhattan map very naively. Here are the steps to load other location:
- change `map_path` to path to your .dot map
- change `n` in `utils.pde` line 80 to number of vertices in your .dot file
- change `transform` function in `utils.pde` (line 57) to transform UTM coordinates to values:
  - between 0 and 1800*9 for x
  - and y accordingly
  - note that my `transform` reverses x and y. Note that 0, 0 in processing is the top left corner
