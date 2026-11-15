# Relinking OCCT with HandCAD

**Before you start:**
- You may modify the Open CASCADE Technology (OCCT) library for your own use, relink HandCAD with it using this kit, and inspect, analyze, test and debug how HandCAD works with your modified OCCT.
- A relinked or modified HandCAD is not a version we built, signed or support. We make no promise that it will install, run or behave as HandCAD does.
- HandCAD's own object files in this kit are for your own use only. They may not be shared, published, sold or used to make another product or service. OCCT itself, and your changes to it, stay under the LGPL 2.1 with the Open CASCADE exception, and you may share those under its terms.
- Full terms: the HandCAD license agreement.

Each release of this repository includes a relink kit. A slice folder in the kit (for example `ios-device` or `ios-simulator`) holds HandCAD's core static archives.

1. Get the OCCT source for the release (see `OCCT-SOURCE.md`) and, if you like, modify it.
2. Rebuild OCCT for the slice you want with `build/build-occt.sh` (it reads `build/occt.env`).
3. Merge HandCAD's archives with your rebuilt OCCT libraries:

```
libtool -static -o libHandCADCore.a \
  libhandcad_base.a libhandcad_solver.a libhandcad_doc.a \
  libhandcad_kernel_occ.a libhandcad_naming.a libhandcad_engine.a \
  <occt>/lib/libTK*.a
```

4. Link the result with the app-level object files from the same release.

`libhandcad_doc.a` contains nlohmann/json 3.12.0, which is MIT licensed (`LICENSES/NLOHMANN-JSON-MIT.txt`).

The app-level object files come from the Xcode archive of each release and are attached to that release. If you cannot reach a download, write to handcadapp@gmail.com.

## What this covers

This lets you rebuild OCCT, modified or not, and relink it with HandCAD's libraries for your own use. We do not promise that a relinked app can be code-signed, installed or run on any device. Apple controls code signing and installation on iPhone, and that is not our decision. A relinked build is yours and may not be presented as HandCAD.
