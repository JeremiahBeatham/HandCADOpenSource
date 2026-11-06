# HandCADOpenSource

Open-source compliance material for the HandCAD iPhone app.

HandCAD links Open CASCADE Technology (OCCT) 7.9.3, which is free software licensed under the GNU Lesser General Public License, version 2.1, with the Open CASCADE Exception 1.0. This repository gives you what you need to get the OCCT source we use, rebuild it (modified or not) and relink it with HandCAD's libraries.

## What is here

- [OCCT-SOURCE.md](OCCT-SOURCE.md): the exact OCCT version we use (tag and commit) and where to get its source.
- [build/](build/): the pin (`occt.env`) and the script (`build-occt.sh`) that builds OCCT the way HandCAD does.
- [RELINK.md](RELINK.md): how to relink a rebuilt OCCT with HandCAD's libraries.
- [LICENSES/](LICENSES/): the LGPL-2.1 text, the Open CASCADE Exception 1.0 and the MIT license of a small bundled library (nlohmann/json 3.12.0).

## Releases

For each released version of the app, a GitHub release in this repository holds the OCCT source we built, the build script and pin for that version, and the relink kit (HandCAD's object files and static archives for each platform slice, and the app-level object files). Material for each version is kept for at least three years after that version's last distribution.

No releases have been published yet; the first one goes up before the app is distributed.

## What this repository is not

It holds no HandCAD application source code. HandCAD's own code is not offered under the LGPL, and the offer here covers OCCT only: it lets you swap in your own build of OCCT.

The scripts in `build/` are provided so you can rebuild OCCT and relink. License terms for them, and the wording of HandCAD's license notices, are being finalized.

## Contact

Questions, support, bugs and feedback: handcadapp@gmail.com
