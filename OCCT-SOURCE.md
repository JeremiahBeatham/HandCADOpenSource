# OCCT source used by HandCAD

| | |
|---|---|
| Library | Open CASCADE Technology (OCCT) |
| Version | 7.9.3 |
| Git tag | `V7_9_3` |
| Git commit | `a016080bf6738d6aeae020badee4e888ad1540a5` |
| Source | https://github.com/Open-Cascade-SAS/OCCT |
| License | GNU LGPL 2.1 with the Open CASCADE Exception 1.0 (see `LICENSES/`) |
| Modified by HandCAD | No |

Get the source:

```
git clone https://github.com/Open-Cascade-SAS/OCCT.git
cd OCCT
git checkout V7_9_3
```

HandCAD builds OCCT statically with a minimal set of modules (FoundationClasses, ModelingData, ModelingAlgorithms, DataExchange). FreeType, FreeImage, Tcl/Tk, TBB, VTK and OpenGL are disabled, so no other third-party code is linked in. The exact flags are in `build/build-occt.sh`; the version pin is `build/occt.env`.
