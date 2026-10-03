from pathlib import Path
import json,html
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle
from PIL import Image
from pypdf import PdfReader
from fontTools.ttLib import TTFont as FT
from fontTools.varLib.instancer import instantiateVariableFont
import fitz
P=Path(__file__).resolve().parents[3];R=P.parent;O=P/'brand/07-guidelines';PR=P/'brand/09-production'
tmp=R/'tmp/pdfs/guide-v2';tmp.mkdir(parents=True,exist_ok=True)
for family,src,weight in [('Guide','lexend/Lexend[wght].ttf',400),('GuideBold','lexend/Lexend[wght].ttf',600),('Title','nunito/Nunito[wght].ttf',800)]:
 f=instantiateVariableFont(FT(PR/'fonts'/src),{'wght':weight},inplace=False);f.save(tmp/(family+'.ttf'));pdfmetrics.registerFont(TTFont(family,str(tmp/(family+'.ttf'))))
pdfmetrics.registerFontFamily('Guide',normal='Guide',bold='GuideBold',italic='Guide',boldItalic='GuideBold')
W,H=960,640;C=canvas.Canvas(str(O/'Lumio-Brand-Guideline-v2.pdf'),pagesize=(W,H));C.setTitle('Lumio Brand Guideline v2');C.setAuthor('Lumio')
COL={'ink':'#38234F','violet':'#7651D6','gold':'#FFD34E','teal':'#20C8C4','mist':'#F4F0FC','cream':'#FFF4D9','slate':'#6A6275','white':'#FFFFFF'};page=0;records=[]
def rect(x,y,w,h,fill,rad=0):
 C.setFillColor(HexColor(COL.get(fill,fill)));C.setStrokeColor(HexColor(COL.get(fill,fill)))
 if rad:C.roundRect(x,H-y-h,w,h,rad,fill=1,stroke=0)
 else:C.rect(x,H-y-h,w,h,fill=1,stroke=0)
def txt(x,y,t,size=12,font='Guide',color='ink'):
 C.setFillColor(HexColor(COL.get(color,color)));C.setFont(font,size);C.drawString(x,H-y-size,t)
def para(x,y,t,w,size=12,color='ink',leading=None):
 st=ParagraphStyle('p',fontName='Guide',fontSize=size,leading=leading or size*1.45,textColor=HexColor(COL.get(color,color)));p=Paragraph(t,st);_,hh=p.wrap(w,1000);assert y+hh<601,(page,t,y,hh);p.drawOn(C,x,H-y-hh);return y+hh
def pic(path,x,y,w,h):
 iw,ih=Image.open(path).size;s=min(w/iw,h/ih);dw,dh=iw*s,ih*s;C.drawImage(str(path),x+(w-dw)/2,H-y-(h-dh)/2-dh,width=dw,height=dh,mask='auto')
def start(kicker,title,sub=''):
 global page
 if page:C.showPage()
 page+=1;rect(0,0,W,H,'mist');txt(42,22,'LUMIO / BRAND GUIDELINE',9,'GuideBold','slate');txt(858,22,f'V2 / {page:02}',9,'GuideBold','slate');txt(42,61,kicker.upper(),10,'GuideBold','violet');txt(42,84,title,31,'Title');
 if sub:para(42,132,sub,875,11,'slate')
 txt(42,614,'Lumio - Play. Learn. Glow.  |  Project baseline / 26 September 2026',8,'Guide','slate')
def card(x,y,w,h,title,body,fill='white',size=11):
 rect(x,y,w,h,fill,16);txt(x+20,y+18,title,16,'Title');para(x+20,y+51,body,w-40,size)
def record(title,body):records.append((title,body))
logo=PR/'logos/lumio-primary-color.png';mascot=PR/'character/lumi-layered-preview.png';icon=P/'brand/04-app-icon/approved/lumio-app-icon.png'
start('01 / The idea','A world made brighter by learning.','For children aged 5-9, with the clarity and care parents expect.')
rect(42,185,876,280,'cream',24);pic(logo,76,201,808,245);txt(42,493,'Play. Learn. Glow.',32,'Title');para(42,544,'Purple brings personality. Gold marks discovery. Turquoise opens the world.',875,14)
record('Brand idea','Lumio is a playful educational game for children aged 5-9. Lumi is a curious companion. The brand is playful, thoughtful and confident. Encourage effort, use natural stopping points, and avoid shame or pressure to return. Tagline: Play. Learn. Glow.')
start('02 / Logo family','Lumi belongs inside the name.','Custom path lettering and an integrated final o. No font substitution or separate mascot lockup.')
rect(42,177,442,402,'white',16);pic(PR/'logos/logo-family-preview.png',62,185,400,382)
para(515,181,'<b>Primary</b><br/>Integrated Lumi for introductions and larger branding.<br/><br/><b>Compact</b><br/>Wordmark for navigation. Small-UI version uses a round dot.<br/><br/><b>Color variants</b><br/>Color, black, white, plum and reverse color. Monochrome apertures remain transparent.<br/><br/><b>Clear space</b><br/>At least 0.25 x the o height beyond all visible artwork. Preserve proportions.',395,11)
para(515,489,'<b>Starting widths</b><br/>Primary 240 px; wordmark 120 px; small UI 80 px. Previewed at these sizes; final thresholds need device testing.',395,11)
record('Logo use','Use brand/09-production/logos for editable SVGs and PNG exports. Primary is the integrated-o logo; wordmark and small-UI alternate cover tighter spaces. Color, black, white, plum and reverse-color variants included. Keep 0.25 times the o height clear around all artwork. Starting widths: 240/120/80 logical px, still subject to device review. No distortion, rotation, added effects or retyped lettering. Vector redraws deliberately flatten source shading; selected PNG references remain for comparison.')
start('03 / Color','Violet leads. Gold celebrates.','Exact sRGB tokens for new artwork and UI. Older generated PNGs have natural color variation.')
pal=json.loads((P/'brand/05-colors/lumio-colors.json').read_text())
for i,(key,v) in enumerate(pal['palette'].items()):
 x=42+(i%4)*222;y=181+(i//4)*105;rect(x,y,210,94,'white',13);rect(x+12,y+12,48,70,v['hex'],8);txt(x+71,y+17,v['name'].replace('Discovery ','').replace('Lumio ',''),10,'GuideBold');txt(x+71,y+41,v['hex'],12);txt(x+71,y+66,','.join(map(str,v['rgb'])),8,'Guide','slate')
para(42,520,'<b>Text:</b> white/violet 5.36:1; plum/gold 9.65:1; plum/turquoise 6.65:1.<br/>White on gold or turquoise fails the 4.5:1 normal-text target. Use plum instead. Ratios apply to the exact solid tokens, not whole-product compliance.',875,11)
record('Color','Exact palette and functional shades: brand/05-colors/lumio-colors.json and .css. Violet #7651D6, Gold #FFD34E, Turquoise #20C8C4; supporting Lilac #B8A0F2, Aqua #65E1D6, Coral #F47B7F, Leaf #43C59E; Plum #38234F, Cream #FFF4D9, White #FFFFFF, Mist #F4F0FC, Slate #6A6275. Functional pressed #5F3DB3, success #216E53, attention #8A5700, error #A53345. White/violet 5.36:1; plum/gold 9.65:1; plum/turquoise 6.65:1. Never use white normal text on gold or turquoise. Pair color with icons and text. Contrast source: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html')
start('04 / Typography','Friendly titles. Clear instructions.','Font files, original licenses, CSS and an offline specimen are bundled.')
card(42,181,280,203,'Nunito','Display / 700-800<br/><br/>Short titles and navigation emphasis. Rounded forms echo Lumi without replacing the custom wordmark.')
card(340,181,280,203,'Lexend','Latin UI / 400-600<br/><br/>English and Bahasa Melayu instructions, choices and parent text. This PDF uses Lexend body text.')
card(638,181,280,203,'Noto Sans Arabic','Arabic / 400-600<br/><br/>Use correct shaping and RTL flow. Preserve diacritic space. See the offline Arabic specimen.')
txt(42,413,'Your next adventure awaits',27,'Title');para(42,458,'How many stars can you see?  /  Mari belajar bersama Lumi.',875,18)
para(42,508,'Title 32/40; section 24/32; child instruction 20/30; choice 18/26; parent text 16/24.<br/>Arabic starts at 22/36. Test 0/O, 1/l/I, math symbols and text scaling in the target engine.',875,11)
record('Typography','Use bundled Nunito 700-800 for display, Lexend 400-600 for English/BM UI and Noto Sans Arabic 400-600 for Arabic. Files are unmodified variable TTFs with original OFL licenses, metadata and source hashes. Starting sizes/line heights: title 32/40, section 24/32, child instruction 20/30, choice 18/26, parent body 16/24, metadata 14/20; Arabic 22/36. Test engine font support, shaping, diacritics, RTL and text scaling. Specimen: brand/09-production/fonts/specimen.html. Sources: https://github.com/google/fonts/tree/main/ofl/nunito ; https://github.com/google/fonts/tree/main/ofl/lexend ; https://github.com/google/fonts/tree/main/ofl/notosansarabic')
start('05 / Character','Simple parts. A recognizable friend.','Flat vector source and separated parts preserve the swept crown, rounded body and golden tail.')
rect(42,178,404,414,'cream',18);pic(mascot,67,189,354,395)
para(482,181,'<b>Keep the identity</b><br/>Swept flame crown, cream eyes, purple body, lavender belly, plum contour and gold-tipped tail.<br/><br/><b>Editable anatomy</b><br/>18 named parts: head, brows, eyes, pupils, mouth, torso/belly, arms, hands, legs, tail and flame.<br/><br/><b>Animation handoff</b><br/>Closed shapes overlap at joints. The rig map specifies draw order, pivots and suggested parents. Individual parts share one coordinate frame.<br/><br/><b>Source format</b><br/>SVG layers and a replayable motion study. Import and rig in your chosen engine; no native Rive, Spine or Lottie rig is claimed.',420,11)
record('Character source','brand/09-production/character/lumi-layered.svg is a hand-authored flat redraw, with 18 named editable groups, individual part SVGs, a monochrome silhouette and rig-map.json. Parts are fully closed and overlap behind joints. Original selected full-body PNG stays in brand/01-mascot/approved. The new SVG is a redraw with small contour differences. This is an animation source kit, not a native engine bone rig. Use small rotations around supplied pivots; large pose extremes need extra drawing.')
start('06 / Reactions','Nine ways to learn together.','Individual transparent PNGs, ready for static UI placement. They are not registered animation frames.')
rs=json.loads((P/'brand/06-character/reactions/reactions-manifest.json').read_text())['assets']
for i,a in enumerate(rs):
 x=42+(i%3)*298;y=180+(i//3)*136;rect(x,y,280,124,'white',14);pic(P/'brand/06-character/reactions'/a['file'],x+4,y+4,112,112);txt(x+122,y+23,a['id'].title(),15,'Title');uses=['Greeting','Start an activity','Invite exploration','Offer a hint','New discovery','Recognize effort','Work through a puzzle','Offer a break','Activity complete'];para(x+122,y+55,uses[i],145,10)
record('Reactions','Nine separate RGBA PNGs: happy, excited, curious, thinking, surprised, proud, confused, sleepy and celebrating. Files, usage manifest and preview are in brand/06-character/reactions. These are static torso-up illustrations with minor pose/scale variation, not a frame atlas. Keep aspect ratio and contain sizing. Confused is Lumi exploring, never judging the child; sleepy invites a break; proud recognizes effort.')
start('07 / Motion','Respond, celebrate, then settle.','A finite wave/nod/tail study is included. Keep motion brief and the hit areas stable.')
rows=[('Press','80-120 ms','Small compression and release.'),('Answer feedback','200-350 ms','One pulse with supportive text.'),('Transition','220-320 ms','Short directional move or fade.'),('Lumi reaction','500-900 ms','Anticipation, expression, then settle.'),('Milestone','800-1200 ms','One flourish; never block progress.')]
for i,(n,t,b) in enumerate(rows):
 y=181+i*61;rect(42,y,876,54,'white',10);txt(60,y+15,n,12,'GuideBold');txt(280,y+15,t,11,'GuideBold','violet');txt(450,y+15,b,11)
para(42,513,'<b>Reduced motion:</b> use immediate states or brief fades. No shake, strobe or endless rewards.<br/>Open character/motion-preview.html to replay the 900 ms wave. Its CSS follows the system reduced-motion preference. Port the timing and pivots into the game engine.',875,11)
record('Motion','Press 80-120ms; answer feedback 200-350ms; transition 220-320ms; reaction 500-900ms; milestone 800-1200ms. A finite 900ms wave/nod/tail HTML/SVG study is included in brand/09-production/character/motion-preview.html. Reduced motion disables that animation. Use text/icons for essential feedback; keep hit areas stable and let celebrations settle. No camera shake, strobing or endless loops. Runtime rigs and game integration are future implementation work.')
start('08 / Sound and voice','Encourage without demanding.','Five original synthesized WAV cues are included as an initial sound palette.')
sounds=[('Startup','0.80 s','Gentle rising three-note chime'),('Correct','0.30 s','Warm pluck with a light harmonic'),('Retry','0.18 s','Quiet neutral tap'),('Reward','0.75 s','Short rising discovery motif'),('Transition','0.18 s','Soft single-tone response')]
for i,(n,t,b) in enumerate(sounds):
 y=181+i*48;txt(42,y,n,12,'GuideBold');txt(215,y,t,11,'Guide','slate');txt(360,y,b,12)
card(42,440,426,143,'Copy that helps','“You found it!”<br/>“Good try. Let’s look again.”<br/>“What do you notice?”<br/>“Ready for a little break?”',size=11)
card(490,440,428,143,'Playback rules','Separate effects and voice controls. Avoid stacked cues. No autoplay in previews. Mix and check loudness in the actual app. Human voice/narration is not included.',size=11)
record('Sound and voice','Five original 44.1kHz mono 16-bit WAV prototype cues: startup 0.8s, correct 0.3s, retry 0.18s, reward 0.75s, transition 0.18s. No recordings or third-party melodies. Peak levels checked; mixing and device listening remain part of implementation. Audio preview and manifest: brand/09-production/audio. Do not stack cues; reward supersedes correct. Provide independent effects/voice controls. No human voice/narration files. Keep all essential feedback visible. Copy: You found it! Good try. Let’s look again. What do you notice? Ready for a little break?')
start('09 / App icon','A lively pose, across platforms.','The approved turquoise wink stays the default. Adaptive layers keep Lumi inside the mask-safe area.')
rect(42,182,276,326,'white',18);pic(icon,65,203,230,230);txt(67,457,'iOS / store / web',13,'GuideBold')
rect(340,182,276,326,'white',18);pic(PR/'icons/android/circle-mask-preview.png',363,203,230,230);txt(365,457,'Android adaptive',13,'GuideBold')
para(647,183,'<b>iOS</b><br/>Opaque 1024px source and AppIcon asset catalog. Optional legacy sizes.<br/><br/><b>Android</b><br/>Legacy densities, 108dp adaptive layers, v26/v33 XML and themed silhouette.<br/><br/><b>Web</b><br/>Flame favicons; mascot touch/PWA icons and starter manifest.',271,11)
para(42,535,'The adaptive foreground was separated with image generation and has small contour differences. Pixel/export checks are complete; device masking, Xcode/Android compilation and store submission belong to app integration.',875,11)
record('App icons','brand/09-production/icons includes iOS AppIcon.appiconset (1024 opaque RGB) plus legacy sizes, Android 48dp legacy density PNGs, separate 108dp foreground/background and monochrome density layers, v26/v33 adaptive XML, 512px store image, and web favicons/PWA icons/manifest. Adaptive foreground was newly generated from the approved wink and fitted to a 63.8dp protected diameter. Apple uses the flat asset-catalog route, not Icon Composer. Export checks are complete; platform compilation and device review are not. Sources: https://developer.apple.com/documentation/xcode/configuring-your-app-icon ; https://developer.android.com/develop/ui/compose/system/icon_design_adaptive')
start('10 / Product expression','One task, clearly presented.','Four visual concepts connect the child adventure to calm parent oversight.')
ui=P/'brand/08-ui/concepts';screens=[('01-child-home.png','Adventure home'),('02-counting-game.png','Counting activity'),('03-activity-complete.png','Activity complete'),('04-parent-overview.png','Parent overview')]
for i,(f,n) in enumerate(screens):
 x=42+i*222;rect(x,180,210,334,'white',14);pic(ui/f,x+8,189,194,280);txt(x+12,482,n,11,'GuideBold')
para(42,537,'Use 56 x 56 logical-pixel child touch targets as a starting point. Pair color, text and icons. Support sound-off, reduced motion, text scaling, focus and Arabic RTL. Screens are visual concepts with fictional sample data.',875,11)
record('UI concept','Four PNG mockups and interaction notes: brand/08-ui/concepts. Adventure home, counting activity, activity complete, parent overview. Child UI: one task, short instructions, large choices and clear progress. Use 56x56 logical-pixel child touch targets as a starting point, tested in the real device layout. Parent UI: calm white/mist surfaces, labeled progress and plain language. Fictional demo data. Support sound-off, reduced motion, text scaling, focus and Arabic RTL. Provide natural stopping and parent-controlled purchasing. These are visual mockups, not a working app or final accessibility audit.')
start('11 / Worlds','Different subjects. One visual language.','Rounded geometry, simple contours and purposeful color. Keep educational content accurate.')
worlds=[('Number Kingdom','Mathematics','Countable objects, geometric bridges and exact quantities.'),('Word Woods','English','Story objects, soft forest forms and readable letters.'),('Language Village','Bahasa Melayu','Reviewed everyday places, food, routines and familiar language.'),('Arabic Oasis','Arabic','Accurate script, light and water; reviewed cultural context.'),('Logic Lab','Reasoning','Friendly machines and clear cause-and-effect sequences.'),('Discovery Island','Science','Nature and weather, with factually accurate learning diagrams.')]
for i,(n,s,b) in enumerate(worlds):
 x=42+(i%3)*298;y=182+(i//3)*196;rect(x,y,280,178,'white',16);txt(x+18,y+20,n,16,'Title');txt(x+18,y+49,s,10,'GuideBold','violet');para(x+18,y+78,b,244,11)
record('Illustration and worlds','Use simple rounded silhouettes and flat/cel color. Number Kingdom: exact math objects; Word Woods: readable letter/story objects; Language Village: reviewed everyday BM examples; Arabic Oasis: culturally reviewed scenes and accurate script; Logic Lab: clear cause/effect; Discovery Island: factual nature/science. These are world directions, not completed levels or lesson content.')
start('12 / Handoff','A complete baseline for the next build.','Open START-HERE.html in the Lumio folder to browse current assets and previews.')
card(42,182,426,231,'Included in this package','Selected references and earlier concepts.<br/>Editable logo family and flat Lumi layers.<br/>Nine separate reactions and expression sheet.<br/>Palette, bundled fonts and brand rules.<br/>iOS, Android and web icon exports.<br/>Motion study, five WAV cues and UI concepts.',size=11)
card(490,182,428,231,'Next: build the game','Add your game structure to game-structure/.<br/>Choose engine and implement screens.<br/>Import fonts, icons and character parts.<br/>Create engine rigs and voice/content if needed.<br/>Review language and educational content.<br/>Test devices, accessibility and final mix.',size=11)
para(42,443,'<b>Source of truth</b><br/>Approved PNGs preserve chosen visual directions. brand/09-production contains new editable/export assets. V2 replaces V1 as the current guide; old notes describe earlier stages. No game logic, playable levels or native engine rig is implied.',875,12)
para(42,532,'<b>References and licenses:</b> complete URLs, font licenses, source metadata and implementation notes are included alongside the assets. Use MANIFEST.json to verify package files and SHA-256 hashes.',875,11)
record('Handoff','This package completes the requested brand/design baseline: references, editable logo family, monochrome/reverse variants, icon exports, palette, font files/licenses, nine separate reactions, layered mascot parts/pivots, motion study, prototype sound kit, guidelines and UI concepts. Game code, playable lessons, engine-specific rigging, human voice, device testing and app-store submission are implementation work. START-HERE.html is the index. game-structure/ is reserved for the user’s architecture. V2 supersedes V1. New vector/export assets are authored baseline deliverables, not a claim of separate user approval or store readiness.')
C.save();assert len(PdfReader(O/'Lumio-Brand-Guideline-v2.pdf').pages)==12
(O/'Lumio-Brand-Guideline-v2.md').write_text('# Lumio Brand Guideline v2\n\n26 September 2026. Current project baseline.\n'+''.join('\n## '+a+'\n\n'+b+'\n' for a,b in records))
cfg=json.loads((O/'brand-guidance.json').read_text());cfg.update({'version':'2.0','status':'authored project baseline; device integration pending','individualReactions':{'requested':9,'generated':9,'status':'included; static RGBA PNGs'},'uiConcepts':{'screens':4,'status':'visual mockups'},'characterSource':{'format':'layered SVG','parts':18,'nativeEngineRig':False},'prototypeSounds':5,'childTouchTargetPx':56});cfg['typography']['fontFilesBundled']=True;(O/'brand-guidance.json').write_text(json.dumps(cfg,indent=2))
(O/'README.md').write_text('# Brand guideline\n\nUse Lumio-Brand-Guideline-v2.pdf or its Markdown counterpart. V2 consolidates current rules and delivered assets, superseding V1. The JSON file provides implementation values. Earlier v1 files are historical.\n')
doc=fitz.open(O/'Lumio-Brand-Guideline-v2.pdf')
for i,p in enumerate(doc):p.get_pixmap(matrix=fitz.Matrix(1,1),alpha=False).save(tmp/f'page-{i+1:02}.png')
print('Wrote and rendered 12-page guide v2')
