# Relinking OCCT with HandCAD

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
