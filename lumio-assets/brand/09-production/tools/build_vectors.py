from pathlib import Path
import json,re,html
R=Path(__file__).resolve().parents[1]; logos=R/'logos'; char=R/'character';logos.mkdir(exist_ok=True);char.mkdir(exist_ok=True)
V='#7651D6';D='#38234F';L='#B8A0F2';Y='#FFD34E';C='#FFF4D9';T='#F47B7F';S='#5F3DB3'
def path(d,fill=V,stroke=None,sw=18,extra=''):
 return f'<path d="{d}" fill="{fill}"'+(f' stroke="{stroke}" stroke-width="{sw}" stroke-linejoin="round" stroke-linecap="round"' if stroke else '')+f' {extra}/>'
def group(id,s):return f'<g id="{id}" inkscape:groupmode="layer" inkscape:label="{id}">{s}</g>'
def svg(s,vb,title):return f'''<svg xmlns="http://www.w3.org/2000/svg" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" viewBox="{vb}" role="img"><title>{title}</title>{s}</svg>'''.replace('http://www.inkscape.org/namespaces/inkscape','http://www.inkscape.org/namespaces/inkscape')
# Individually closed shapes extend behind joints so rotations do not expose holes.
parts={}
parts['tail']=path('M744 897 C845 977 964 948 987 859 C1002 800 947 788 983 725 C1000 766 1061 787 1071 840 C1096 973 964 1102 778 1022 Z',V,D)
parts['tail-flame']=path('M977 563 C1018 542 1108 603 1117 675 C1141 742 1102 780 1047 799 C1022 767 975 763 988 725 C963 736 956 758 959 777 C907 740 928 697 962 660 C999 624 1007 596 977 563 Z',Y,D)
parts['leg-left']=path('M432 990 C399 1040 427 1071 467 1093 C400 1090 353 1118 356 1152 C361 1198 537 1188 565 1137 C589 1108 549 1078 559 1031 Z',V,D)
parts['leg-right']=path('M601 1003 C608 1052 655 1082 681 1110 C643 1143 661 1182 715 1194 C789 1210 880 1198 873 1163 C869 1126 817 1101 772 1102 C806 1053 782 1009 743 976 Z',V,D)
parts['arm-left']=path('M496 705 C436 675 396 704 351 679 C318 660 299 635 277 605 L225 646 C244 725 280 778 355 786 C410 791 458 761 490 731 Z',V,D)
parts['hand-left']=path('M245 672 C201 675 161 646 165 602 C169 565 202 543 240 557 C223 520 250 496 277 521 C306 545 314 578 305 613 C307 638 286 668 263 674 Z',V,D)
parts['torso']=path('M506 672 C550 658 611 666 656 690 C713 711 715 771 737 838 C758 898 805 985 756 1023 C683 1061 519 1054 433 1015 C354 980 370 893 397 823 C427 753 465 700 506 672 Z',V,D)
parts['belly']=path('M514 724 C575 697 629 810 644 898 C661 982 634 1020 568 1027 C472 1034 407 982 421 898 C428 832 465 743 514 724 Z',L)
parts['arm-right']=path('M652 718 C689 696 724 752 751 782 C785 810 817 832 823 871 C828 902 790 926 760 908 C728 883 707 860 682 840 C650 816 632 766 652 718 Z',V,D)
parts['hand-right']=path('M766 826 C798 823 822 854 828 893 C839 933 811 974 777 982 C743 992 720 971 718 940 C699 962 681 937 691 906 C702 867 732 835 766 826 Z',V,D)
head=path('M666 64 C732 52 825 108 846 185 C862 227 849 255 841 277 C862 273 880 255 888 237 C940 292 954 364 935 426 C928 477 900 523 865 551 C881 628 806 695 680 708 C575 714 424 689 356 613 C300 550 321 464 359 397 C370 299 448 222 544 191 C634 160 723 148 676 82 Z',V,D,20)
parts['head']=head
parts['brow-left']=path('M470 299 C483 265 525 251 548 273 C563 292 547 304 531 294 C508 283 486 297 476 302 Z',D)
parts['brow-right']=path('M744 319 C772 299 812 341 811 372 C812 391 803 383 795 371 C781 351 764 344 745 338 C735 335 733 326 744 319 Z',D)
parts['eye-left']=f'<ellipse cx="474" cy="436" rx="64" ry="99" transform="rotate(19 474 436)" fill="{C}" stroke="{D}" stroke-width="9"/>'
parts['eye-right']=f'<ellipse cx="715" cy="486" rx="72" ry="99" transform="rotate(19 715 486)" fill="{C}" stroke="{D}" stroke-width="9"/>'
parts['pupil-left']=f'<ellipse cx="484" cy="460" rx="32" ry="56" transform="rotate(16 484 460)" fill="{D}"/><circle cx="474" cy="422" r="20" fill="{C}"/>'
parts['pupil-right']=f'<ellipse cx="720" cy="508" rx="36" ry="55" transform="rotate(16 720 508)" fill="{D}"/><circle cx="698" cy="474" r="20" fill="{C}"/>'
parts['mouth']=path('M510 539 C549 562 584 565 622 553 C637 541 632 587 610 614 C577 659 532 629 517 595 C507 573 503 546 510 539 Z',D)+path('M524 595 C546 573 584 575 609 595 C582 640 548 633 524 595 Z',T)
order=['tail-flame','tail','leg-left','leg-right','arm-left','hand-left','torso','belly','arm-right','hand-right','head','brow-left','brow-right','eye-left','eye-right','pupil-left','pupil-right','mouth']
assembled=''.join(group(i,parts[i]) for i in order)
(char/'lumi-layered.svg').write_text(svg(assembled,'120 20 1030 1210','Lumi - editable layered vector redraw'))
for i in order:
 (char/'parts').mkdir(exist_ok=True);(char/'parts'/f'{i}.svg').write_text(svg(group(i,parts[i]),'120 20 1030 1210','Lumi '+i))
pivots={'tail':[792,971],'tail-flame':[1001,760],'leg-left':[493,1033],'leg-right':[671,1029],'arm-left':[468,720],'hand-left':[275,635],'torso':[570,859],'belly':[549,884],'arm-right':[671,757],'hand-right':[758,865],'head':[594,693],'brow-left':[506,284],'brow-right':[775,341],'eye-left':[474,436],'eye-right':[715,486],'pupil-left':[484,460],'pupil-right':[720,508],'mouth':[569,586]}
(char/'rig-map.json').write_text(json.dumps({'version':1,'units':'SVG viewBox units','viewBox':[120,20,1030,1210],'root':'torso','drawOrder':order,'parts':[{ 'id':i,'file':'parts/'+i+'.svg','pivot':pivots[i],'parent':('head' if i in order[11:] else 'arm-left' if i=='hand-left' else 'arm-right' if i=='hand-right' else 'tail' if i=='tail-flame' else 'torso' if i!='torso' else None)} for i in order],'note':'SVG source is a flat draw stack. Parent relationships here are rig assembly instructions; not an imported bone rig. All parts share the original coordinate frame.'},indent=2))
# Closed filled outlines for the wordmark. No fonts, embedded bitmaps, or raster tracing fragments.
letters={
'l':'M233 373 C233 296 345 296 345 373 L345 582 C345 612 354 620 376 635 C416 663 396 722 349 722 C276 722 233 667 233 589 Z',
'u':'M389 489 C389 415 499 415 499 489 L499 575 C499 611 518 632 548 632 C580 632 598 609 598 575 L598 489 C598 416 708 416 708 489 L708 576 C708 667 638 727 548 727 C458 727 389 669 389 576 Z',
'm':'M718 564 C718 482 778 423 851 423 C890 423 922 437 945 465 C970 437 1002 423 1042 423 C1118 423 1178 482 1178 564 L1178 668 C1178 739 1071 739 1071 668 L1071 564 C1071 539 1058 521 1036 521 C1013 521 999 539 999 564 L999 668 C999 739 890 739 890 668 L890 564 C890 539 876 521 854 521 C830 521 817 539 817 564 L817 668 C817 739 718 739 718 668 Z',
'i':'M1191 490 C1191 416 1299 416 1299 490 L1299 668 C1299 739 1191 739 1191 668 Z',
'o':'M1481 423 C1585 423 1660 488 1660 576 C1660 666 1585 730 1481 730 C1378 730 1305 666 1305 576 C1305 488 1378 423 1481 423 Z M1481 507 C1440 507 1414 537 1414 575 C1414 615 1440 642 1481 642 C1523 642 1551 615 1551 575 C1551 537 1523 507 1481 507 Z'}
word=''.join(group('letter-'+k,path(d,V,extra='fill-rule="evenodd"')) for k,d in letters.items())
accent=path('M1271 299 C1299 330 1312 367 1290 399 C1275 421 1254 428 1231 418 C1204 407 1192 385 1201 360 C1211 334 1249 324 1271 299 Z',Y)
logohead=''.join(group('logo-'+i,parts[i]) for i in ['head','brow-left','brow-right','eye-left','eye-right','pupil-left','pupil-right','mouth'])
logotail=path('M1617 557 C1647 555 1681 520 1668 481 C1655 451 1666 438 1675 431 C1684 462 1717 463 1718 498 C1721 550 1678 590 1631 598 Z',V,D,10)
logoflame=path('M1672 342 C1720 335 1760 398 1743 434 C1735 453 1719 462 1702 467 C1680 452 1670 441 1678 426 C1664 431 1660 442 1661 451 C1633 431 1641 402 1655 385 C1680 359 1680 354 1672 342 Z',Y,D,10)
hands=path('M1388 389 C1419 380 1440 397 1439 421 C1437 443 1424 449 1417 434 C1417 452 1398 454 1392 439 C1384 449 1365 449 1358 434 C1346 413 1366 393 1388 389 Z',V,D,10)+path('M1559 400 C1587 398 1617 411 1618 437 C1619 461 1602 469 1591 453 C1584 467 1566 466 1562 451 C1544 460 1534 445 1539 429 C1541 412 1548 404 1559 400 Z',V,D,10)
primary=group('logo-tail',logoflame+logotail)+group('logo-neck',path('M1428 369 C1460 361 1535 366 1560 387 L1561 429 Q1490 411 1423 430 Z',V,D,10))+word+group('i-flame',accent)+f'<g transform="translate(1215 61) scale(.48)">{logohead}</g>'+group('gripping-hands',hands)
wordmark=word+group('i-flame',accent)
small=word+f'<circle cx="1245" cy="366" r="52" fill="{Y}"/>'

def mono(s,color,vb,title):
 # Outline and body merge; cream eye apertures and the mouth become transparent negative space.
 a=s.replace(V,'#FFFFFF').replace(L,'#FFFFFF').replace(Y,'#FFFFFF').replace(S,'#FFFFFF').replace(C,'#000000').replace(D,'#FFFFFF').replace(T,'#FFFFFF')
 # Mouth opening is punched out; tongue stays solid for a smiling negative-space contour.
 a=a.replace('d="M510 539 C549 562 584 565 622 553 C637 541 632 587 610 614 C577 659 532 629 517 595 C507 573 503 546 510 539 Z" fill="#FFFFFF"','d="M510 539 C549 562 584 565 622 553 C637 541 632 587 610 614 C577 659 532 629 517 595 C507 573 503 546 510 539 Z" fill="#000000"')
 x,y,w,h=vb.split();return svg(f'<defs><mask id="ink" maskUnits="userSpaceOnUse" x="{x}" y="{y}" width="{w}" height="{h}"><rect x="{x}" y="{y}" width="{w}" height="{h}" fill="black"/>{a}</mask></defs><rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{color}" mask="url(#ink)"/>',vb,title)
for name,s,vb in [('primary',primary,'205 45 1575 715'),('wordmark',wordmark,'205 275 1485 485'),('small-ui',small,'205 290 1485 470')]:
 (logos/f'lumio-{name}-color.svg').write_text(svg(s,vb,'Lumio '+name+' vector master'))
 for variant,col in [('black','#000000'),('white','#FFFFFF'),('plum',D)]:
  (logos/f'lumio-{name}-{variant}.svg').write_text(mono(s,col,vb,'Lumio '+name+' '+variant))
 # Reverse palette keeps facial detail with a white wordmark, allowing clear reading on plum.
 reverse=s.replace('fill="'+V+'"','fill="#FFFFFF"') if name!='primary' else s.replace(word,word.replace(V,'#FFFFFF'))
 (logos/f'lumio-{name}-reverse.svg').write_text(svg(reverse,vb,'Lumio '+name+' reverse color'))
# Compact flame symbol, deliberately bold for favicons.
flame=path('M51 5 C65 27 65 41 56 54 C76 50 83 35 84 30 C108 55 113 81 103 100 C91 125 57 134 32 120 C0 101 3 73 24 51 C44 31 58 28 51 5 Z',Y)
(logos/'lumio-flame-symbol.svg').write_text(svg(flame,'0 0 128 136','Lumio glow symbol'))
(char/'lumi-silhouette.svg').write_text(mono(assembled,D,'120 20 1030 1210','Lumi monochrome silhouette'))
# Independently replayable, finite SVG motion studies; explicit reduced-motion support.
style='''<style>svg{width:min(420px,90vw);height:440px;overflow:visible}#head-bob{transform-origin:594px 693px}.playing #head-bob{animation:nod .9s ease-in-out}.playing #wave-arm{animation:wave .9s ease-in-out;transform-origin:468px 720px}.playing #tail-motion{animation:tail .9s ease-in-out;transform-origin:792px 971px}@keyframes nod{0%,100%{transform:rotate(0)}40%{transform:rotate(-3deg)}70%{transform:rotate(2deg)}}@keyframes wave{0%,100%{transform:rotate(0)}25%{transform:rotate(-12deg)}55%{transform:rotate(8deg)}80%{transform:rotate(-6deg)}}@keyframes tail{0%,100%{transform:rotate(0)}50%{transform:rotate(-5deg)}}@media(prefers-reduced-motion:reduce){.playing *{animation:none!important}}body{margin:0;background:#F4F0FC;color:#38234F;font-family:system-ui;padding:36px;text-align:center}button{background:#7651D6;color:white;border:0;padding:16px 24px;border-radius:16px;font:600 18px system-ui;cursor:pointer}button:focus-visible{outline:3px solid #38234F;outline-offset:4px}p{max-width:620px;margin:20px auto;line-height:1.6}</style>'''
anim=group('tail-motion',parts['tail-flame']+parts['tail'])+parts['leg-left']+parts['leg-right']+group('wave-arm',parts['arm-left']+parts['hand-left'])+parts['torso']+parts['belly']+parts['arm-right']+parts['hand-right']+group('head-bob',''.join(parts[i] for i in order[10:]))
(char/'motion-preview.html').write_text('<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lumi motion studies</title>'+style+'<h1>Hello, Lumi.</h1><p>A short wave, head nod and tail response. Press to replay.</p><div id="stage">'+svg(anim,'120 20 1030 1210','Animated Lumi wave study')+'</div><button id="play">Play wave</button><p>Reduced motion follows your system preference. This is an editable SVG motion study, ready to guide the game animator.</p><script>const b=document.getElementById("play"),s=document.getElementById("stage");b.onclick=()=>{s.classList.remove("playing");void s.offsetWidth;s.classList.add("playing")};s.addEventListener("animationend",()=>s.classList.remove("playing"));</script></html>')
(char/'README.md').write_text('''# Lumi animation source

`lumi-layered.svg` is a hand-authored flat vector redraw of the approved full-body reference. All visible geometry is editable; no embedded PNG. Open in a vector editor. Eighteen named groups separate crown/head, face, torso/belly, arms, hands, legs, tail and flame. Individual same-canvas SVG and PNG files are in `parts/`.

`rig-map.json` supplies draw order, pivot coordinates and suggested parents. Parts are closed shapes with overlap behind joints. Full leg/arm rotation extremes have not been authored; use small rotations for the reference pose. The SVG itself is a flat draw stack, not a native Spine/Rive/Lottie bone rig. Reparent parts according to the map when importing into your chosen engine. Preserve viewBox offsets; do not auto-trim individual parts.

`motion-preview.html` is a finite, replayable wave/nod/tail study with reduced-motion support. Nine static reactions stay in `brand/06-character/reactions/`; they are separate artwork rather than registered animation frames.

This redraw makes the palette flat and shapes editable; small contour differences from the approved generated reference are intentional. Keep the approved PNG as the visual comparison source.
''')
(logos/'README.md').write_text('''# Editable Lumio logo family

Primary: `lumio-primary-color.svg` integrates Lumi into the final o. Compact: `lumio-wordmark-color.svg`. Small UI: `lumio-small-ui-color.svg`, with a simpler round dot. Flame symbol: favicon / compact supporting mark.

Each lettering asset includes color, black, white, plum and reverse-color versions. White and black are true one-ink assets with transparent eye and mouth openings. White may appear blank in a white-background viewer. SVG masks preserve negative space; expand/flatten masks if your print workflow requires compound paths.

These are editable vector redraws based on selected wordmark A and the approved integrated composition, using exact brand palette tokens. All lettering is custom path geometry, not a font or embedded bitmap. They intentionally flatten the generated source shading. Approved PNG references remain in their original folders. Review the redraw in the final UI before freezing a release.

Clear space: at least one quarter of the o height beyond visible crown, tail and lettering. Starting widths: primary 240 logical px; wordmark 120; small UI 80. Use the included preview to compare at small sizes; test on actual displays before setting final minimums. Do not use superseded side-by-side drafts as the primary.
''')
print('Built',len(list(logos.glob('*.svg'))),'logo SVGs;',len(parts),'character layers')
