# Lumi animation source

`lumi-layered.svg` is a hand-authored flat vector redraw of the approved full-body reference. All visible geometry is editable; no embedded PNG. Open in a vector editor. Eighteen named groups separate crown/head, face, torso/belly, arms, hands, legs, tail and flame. Individual same-canvas SVG and 1030 x 1210 PNG files are in `parts/`.

`rig-map.json` supplies draw order, pivot coordinates and suggested parents. Parts are closed shapes with overlap behind joints. Full leg/arm rotation extremes have not been authored; use small rotations for the reference pose. The SVG itself is a flat draw stack, not a native Spine/Rive/Lottie bone rig. Reparent parts according to the map when importing into your chosen engine. Preserve viewBox offsets; do not auto-trim individual parts.

`motion-preview.html` is a finite, replayable wave/nod/tail study with reduced-motion support. Nine static reactions stay in `brand/06-character/reactions/`; they are separate artwork rather than registered animation frames.

This redraw makes the palette flat and shapes editable; small contour differences from the approved generated reference are intentional. Keep the approved PNG as the visual comparison source.
