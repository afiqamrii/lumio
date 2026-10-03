from pathlib import Path
import json,math,wave,struct,hashlib,html
R=Path(__file__).resolve().parents[1];F=R/'fonts';A=R/'audio';A.mkdir(exist_ok=True)
(F/'fonts.css').write_text('''@font-face{font-family:Nunito;src:url("nunito/Nunito[wght].ttf") format("truetype");font-weight:200 1000;font-display:swap}
@font-face{font-family:Lexend;src:url("lexend/Lexend[wght].ttf") format("truetype");font-weight:100 900;font-display:swap}
@font-face{font-family:"Noto Sans Arabic";src:url("notosansarabic/NotoSansArabic[wdth,wght].ttf") format("truetype");font-weight:100 900;font-stretch:normal;font-display:swap}
:root{--font-display:Nunito,system-ui,sans-serif;--font-body:Lexend,system-ui,sans-serif;--font-arabic:"Noto Sans Arabic",sans-serif}
:lang(ar){font-family:var(--font-arabic);line-height:1.65}
''')
(F/'specimen.html').write_text('''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lumio type specimen</title><link rel="stylesheet" href="fonts.css"><style>body{font-family:var(--font-body);background:#F4F0FC;color:#38234F;margin:0;padding:40px;line-height:1.6}main{max-width:900px;margin:auto}section{background:white;padding:28px;border-radius:20px;margin:20px 0}h1,h2{font-family:var(--font-display);font-weight:800}h1{font-size:40px}h2{font-size:28px}p{font-size:20px}.small{font-size:14px}.arabic{font-size:32px}</style><main><h1>Play. Learn. Glow.</h1><p>Offline font specimen - bundled font files</p><section><h2>Nunito 800 / titles</h2><h2>Your next adventure awaits</h2><p>Lexend 400 / learning text<br>How many stars can you see?<br>Mari belajar bersama Lumi.</p><p style="font-weight:600">Lexend 600 / choices &amp; buttons</p><p>0 O · 1 l I · 6 9 · 2 + 3 = 5 · × ÷ −</p></section><section><h2>Noto Sans Arabic / script specimen</h2><p class="arabic" lang="ar" dir="rtl">مَرْحَبًا! هَيَّا نَتَعَلَّمُ مَعًا.</p><p class="arabic" lang="ar" dir="rtl">١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩ ١٠</p><p class="small">Typography sample only. Learning content needs language and curriculum review. Test shaping, diacritics, line height and RTL in the target engine.</p></section><p class="small">Each font folder includes its original OFL license and metadata. The Lumio wordmark uses custom paths, not these fonts.</p></main></html>''')
(F/'README.md').write_text('''# Lumio typography

Bundled unmodified variable TrueType fonts: Nunito (display 700-800), Lexend (Latin UI/learning 400-600), Noto Sans Arabic (Arabic 400-600). Each folder contains its original OFL.txt and Google Fonts metadata. `sources.json` records download locations and SHA-256 fingerprints. Preserve licenses when redistributing.

Load `fonts.css` for web prototypes; `specimen.html` works locally. For native/game-engine use, import the .ttf files through that engine's font pipeline; export static instances if it cannot handle variable fonts. The custom wordmark is separate SVG geometry.

Starting scale in logical px: title 32/40, section 24/32, child instruction 20/30, choice 18/26, parent body 16/24, metadata 14/20. Arabic starts at 22/36 and needs content-specific diacritic/RTL checks. Do not imply any font by itself guarantees reading accessibility.
''')
# Original soft synthetic motifs. No recordings, licensed samples, or third-party melodies.
sr=44100
sounds=[('startup',.8,[(0,523.25,.35,.15),(.17,659.25,.35,.15),(.34,783.99,.45,.17)]),('correct',.3,[(0,783.99,.28,.17),(.02,1567.98,.18,.035)]),('retry',.18,[(0,330,.17,.13)]),('reward',.75,[(0,659.25,.29,.13),(.16,783.99,.3,.14),(.32,1046.5,.4,.15)]),('transition',.18,[(0,587.33,.17,.08)])]
manifest=[]
for name,duration,notes in sounds:
 values=[]
 for n in range(round(sr*duration)):
  t=n/sr;v=0
  for onset,freq,decay,amp in notes:
   dt=t-onset
   if 0<=dt<decay:
    env=min(1,dt/.008)*math.exp(-5*dt/decay)*min(1,(decay-dt)/.03)
    v+=amp*env*(math.sin(2*math.pi*freq*dt)+.18*math.sin(2*math.pi*2*freq*dt))
  values.append(v)
 pcm=[max(-32767,min(32767,round(x*32767))) for x in values]
 out=A/f'lumio-{name}.wav'
 with wave.open(str(out),'wb') as w:w.setparams((1,2,sr,0,'NONE','not compressed'));w.writeframes(struct.pack('<'+'h'*len(pcm),*pcm))
 peak=max(abs(v) for v in values)
 manifest.append({'id':name,'file':out.name,'durationSeconds':duration,'sampleRate':sr,'channels':1,'bitsPerSample':16,'peakDbFS':round(20*math.log10(peak),2),'origin':'original mathematical synthesis','status':'prototype cue; mix in app'})
(A/'audio-manifest.json').write_text(json.dumps(manifest,indent=2))
(A/'preview.html').write_text('<!doctype html><html lang="en"><meta charset="utf-8"><title>Lumio sound palette</title><style>body{font-family:system-ui;margin:40px;background:#F4F0FC;color:#38234F}section{padding:20px;background:white;margin:16px 0;border-radius:20px;max-width:560px}</style><h1>Lumio sound palette</h1><p>Original prototype cues. Playback starts only when you press play.</p>'+''.join(f'<section><h2>{m["id"].title()}</h2><audio controls preload="none" src="{m["file"]}"></audio></section>' for m in manifest)+'</html>')
(A/'README.md').write_text('''# Lumio sound palette

Five original synthesized WAV cues: startup, correct, retry, reward and transition. 44.1 kHz, mono, 16-bit PCM. No imported recordings or third-party melodies. Sources are reproducible in `../tools/build_support.py`. `preview.html` has manual playback controls; no autoplay.

These are prototype cues for the baseline. Peaks are conservative and checked for clipping, but loudness must be balanced against voice/music and tested on real speakers. Do not repeat/stack sounds; let reward supersede correct; throttle repeated input sounds. Retry is a quiet neutral tap, never a buzzer. Expose independent effects/voice controls. Essential information always remains in text or visuals. Human character voice and narration are outside this asset baseline.
''')
(R/'icons/README.md').write_text('''# Lumio platform icon exports

## iOS
Import `ios/AppIcon.appiconset` into Assets.xcassets. It contains a 1024 x 1024 opaque RGB PNG and single-size universal iOS Contents.json. Xcode can generate smaller appearances. `ios/legacy-sizes/` contains optional older pixel sizes; do not import them as a second primary icon set. This is the flat asset-catalog route, not an Icon Composer .icon file; dark/clear/tinted appearances need platform-specific design and device review if adopted.

## Android
Copy `android/res/` into the Android app's res directory. Set `android:icon="@mipmap/ic_launcher"` in the application manifest. Legacy PNGs cover mdpi through xxxhdpi. Adaptive v26 resources have separate 108dp foreground/background layers; v33 adds a monochrome layer. Color foreground comes from a transparent re-creation of the approved wink pose; it has small contour differences from the original PNG. Important foreground pixels fit inside a 63.8dp diameter circle within the 66dp protected region. The themed icon uses the vector Lumi silhouette. Background extends to all edges. Circle preview is for review, not a launcher asset.

`android/store/` contains the 512px listing image, which uses the original approved artwork. Adaptive foreground, background and monochrome 1080px sources are included for editing.

## Web
16/32/48px flame favicons; 180px touch icon; 192/512px mascot icons and a starter webmanifest. Update start_url, scope and deployment URLs when installing into a real app. PNG favicons can be linked directly; no ICO is required by this baseline.

## Validation scope
Pixel dimensions, alpha, resource names and protected-region coverage are checked. Xcode compilation, Android builds, launcher devices, actual appearance and store upload have not been run. Device checks belong to game integration. Sources checked 2026-09-26:
- https://developer.apple.com/documentation/xcode/configuring-your-app-icon
- https://developer.android.com/develop/ui/compose/system/icon_design_adaptive
''')
print('Typography setup and five original WAV cues complete')
