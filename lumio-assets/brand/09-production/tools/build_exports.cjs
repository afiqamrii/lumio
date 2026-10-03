const fs=require('fs'),path=require('path');
const sharp=require(process.env.CODEX_PRIMARY_RUNTIME_NODE_MODULES?process.env.CODEX_PRIMARY_RUNTIME_NODE_MODULES+'/sharp':'sharp');
const R=path.resolve(__dirname,'..'),P=path.resolve(R,'..'),icons=path.join(R,'icons');
const mkdir=p=>fs.mkdirSync(p,{recursive:true});const write=(p,s)=>{mkdir(path.dirname(p));fs.writeFileSync(p,s)};
(async()=>{
for(const f of fs.readdirSync(R+'/logos').filter(x=>x.endsWith('.svg')))await sharp(R+'/logos/'+f).resize({width:1600}).png().toFile(R+'/logos/'+f.replace('.svg','.png'));
await sharp(R+'/character/lumi-layered.svg').resize({height:1200}).png().toFile(R+'/character/lumi-layered-preview.png');
for(const f of fs.readdirSync(R+'/character/parts').filter(f=>f.endsWith('.svg')))await sharp(R+'/character/parts/'+f).resize(1030,1210).png().toFile(R+'/character/parts/'+f.replace('.svg','.png'));
const icon=P+'/04-app-icon/approved/lumio-app-icon.png';
mkdir(icons+'/ios/AppIcon.appiconset');
await sharp(icon).resize(1024,1024).removeAlpha().png().toFile(icons+'/ios/AppIcon.appiconset/lumio-1024.png');
write(icons+'/ios/AppIcon.appiconset/Contents.json',JSON.stringify({images:[{filename:'lumio-1024.png',idiom:'universal',platform:'ios',size:'1024x1024'}],info:{author:'Lumio',version:1}},null,2));
mkdir(icons+'/ios/legacy-sizes');for(const s of [20,29,40,58,60,76,80,87,120,152,167,180])await sharp(icon).resize(s,s).removeAlpha().png().toFile(icons+`/ios/legacy-sizes/lumio-${s}.png`);
mkdir(icons+'/android/store');await sharp(icon).resize(512,512).removeAlpha().png().toFile(icons+'/android/store/lumio-play-store-512.png');
// Fit every opaque foreground pixel inside the circular 66dp protected region.
const source=R+'/character/lumi-icon-foreground-source.png';const {data,info}=await sharp(source).ensureAlpha().raw().toBuffer({resolveWithObject:true});
let x0=info.width,y0=info.height,x1=0,y1=0;for(let y=0;y<info.height;y++)for(let x=0;x<info.width;x++)if(data[(y*info.width+x)*4+3]>8){x0=Math.min(x0,x);x1=Math.max(x1,x);y0=Math.min(y0,y);y1=Math.max(y1,y)}
const cx=(x0+x1)/2,cy=(y0+y1)/2;let r=0;for(let y=0;y<info.height;y++)for(let x=0;x<info.width;x++)if(data[(y*info.width+x)*4+3]>8)r=Math.max(r,Math.hypot(x-cx,y-cy));
const scale=319/r;const fw=Math.round(info.width*scale),fh=Math.round(info.height*scale);const layer=await sharp(source).resize(fw,fh).png().toBuffer();
const left=Math.round(540-cx*scale),top=Math.round(540-cy*scale);mkdir(icons+'/android/source');
const foreground=await sharp({create:{width:1080,height:1080,channels:4,background:'#00000000'}}).composite([{input:layer,left,top}]).png().toBuffer();fs.writeFileSync(icons+'/android/source/foreground-1080.png',foreground);
const bg=`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1080 1080"><rect width="1080" height="1080" fill="#20C8C4"/><path d="M0 240 Q400 800 1080 970 L1080 1080 Q400 970 0 440Z" fill="#65E1D6"/><path d="M0 750 Q450 1140 1080 1080 L1080 1150 L0 1150Z" fill="#65E1D6"/></svg>`;
write(icons+'/android/source/background.svg',bg);
const mono=await sharp(R+'/character/lumi-silhouette.svg').resize({width:490,height:590,fit:'contain',background:'#00000000'}).png().toBuffer();
const monolayer=await sharp({create:{width:1080,height:1080,channels:4,background:'#00000000'}}).composite([{input:mono,left:295,top:245}]).png().toBuffer();
fs.writeFileSync(icons+'/android/source/monochrome-1080.png',monolayer);
for(const [density,scale] of Object.entries({mdpi:1,hdpi:1.5,xhdpi:2,xxhdpi:3,xxxhdpi:4})){
 const out=icons+'/android/res/mipmap-'+density;mkdir(out);
 await sharp(icon).resize(Math.round(48*scale),Math.round(48*scale)).removeAlpha().png().toFile(out+'/ic_launcher.png');
 for(const [name,input] of [['foreground',foreground],['monochrome',monolayer],['background',Buffer.from(bg)]])await sharp(input).resize(Math.round(108*scale),Math.round(108*scale)).png().toFile(out+'/ic_launcher_'+name+'.png');
}
const adaptive=(mono)=>`<?xml version="1.0" encoding="utf-8"?>\n<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android"><background android:drawable="@mipmap/ic_launcher_background"/><foreground android:drawable="@mipmap/ic_launcher_foreground"/>${mono?'<monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>':''}</adaptive-icon>\n`;
write(icons+'/android/res/mipmap-anydpi-v26/ic_launcher.xml',adaptive(false));write(icons+'/android/res/mipmap-anydpi-v33/ic_launcher.xml',adaptive(true));
mkdir(icons+'/web');
for(const n of [16,32,48,180,192,512]){
 const s=n<64?Buffer.from(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160"><rect width="160" height="160" rx="32" fill="#7651D6"/><g transform="translate(30 26) scale(.78)">${fs.readFileSync(R+'/logos/lumio-flame-symbol.svg','utf8').replace(/^.*?<title>.*?<\/title>/s,'').replace(/<\/svg>\s*$/,'')}</g></svg>`):icon;
 await sharp(s).resize(n,n).png().toFile(icons+`/web/lumio-${n}.png`);
}
write(icons+'/web/site.webmanifest',JSON.stringify({name:'Lumio',short_name:'Lumio',start_url:'/',display:'standalone',background_color:'#FFF4D9',theme_color:'#7651D6',icons:[192,512].map(n=>({src:`lumio-${n}.png`,sizes:`${n}x${n}`,type:'image/png',purpose:'any'}))},null,2));
// Review panels: export variants on explicit surfaces; these are previews only.
const panels=[];let y=0;
for(const [name,bgcolor] of [['primary-color','#FFF4D9'],['primary-black','#FFFFFF'],['primary-white','#38234F'],['primary-reverse','#38234F']]){
 const b=await sharp(R+'/logos/lumio-'+name+'.svg').resize({width:720,height:280,fit:'contain',background:'#00000000'}).png().toBuffer();
 panels.push({input:await sharp({create:{width:800,height:320,channels:4,background:bgcolor}}).composite([{input:b,left:40,top:20}]).png().toBuffer(),left:0,top:y});y+=320;
}
await sharp({create:{width:800,height:1280,channels:4,background:'white'}}).composite(panels).png().toFile(R+'/logos/logo-family-preview.png');
const comp=await sharp(Buffer.from(bg)).resize(1080).composite([{input:foreground}]).png().toBuffer();
const mask=Buffer.from('<svg width="1080" height="1080"><circle cx="540" cy="540" r="360" fill="white"/></svg>');
const masked=await sharp(comp).composite([{input:mask,blend:'dest-in'}]).png().toBuffer();await sharp(masked).trim().resize(480,480).png().toFile(icons+'/android/circle-mask-preview.png');
write(icons+'/export-manifest.json',JSON.stringify({source:'brand/04-app-icon/approved/lumio-app-icon.png',ios:'1024 opaque RGB PNG and universal AppIcon.appiconset; optional legacy sizes',android:'48dp legacy densities; 108dp foreground/background and monochrome densities; v26 and v33 adaptive XML',adaptiveForeground:'New transparent separation derived using image generation from approved wink icon',foregroundSafeRadiusDp:31.9,web:'16/32/48 flame favicons; 180/192/512 mascot icons; webmanifest',deviceTested:false,sourceUrls:['https://developer.apple.com/documentation/xcode/configuring-your-app-icon','https://developer.android.com/develop/ui/compose/system/icon_design_adaptive']},null,2));
console.log('Logo renders, iOS/Android/web exports and visual previews complete.');
})();
