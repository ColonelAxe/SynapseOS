// Explicit map tools: interaction never depends on discovering a double click.
let mapMode='grid',lineStart=null,pendingMapMarker=null,mapPointer=null,mapHover=null;
state.mapLines=Array.isArray(state.mapLines)?state.mapLines:[];
const editbar=document.createElement('div');editbar.className='map-editbar';editbar.setAttribute('aria-label','Map editing tools');
editbar.innerHTML='<button data-map-mode="marker">⌖ Map markers menu</button><button data-map-mode="line">╱ Line drawing</button><button data-map-mode="grid" class="active">▦ Grid selector</button><button data-map-mode="inspect">⊙ Inspect unit</button>';
$('#map-wrap').before(editbar);
function setMapMode(mode,openMenu=true){
 mapMode=mode;lineStart=null;
 if(mode==='inspect'){toast('Click a friendly symbol to inspect its team');drawMap();}
 if(mode!=='marker')pendingMapMarker=null;
 $$('[data-map-mode]').forEach(b=>{b.classList.toggle('active',b.dataset.mapMode===mode);b.setAttribute('aria-pressed',String(b.dataset.mapMode===mode))});
 $('.map-note').innerHTML='<i></i> '+({marker:'MAP MARKERS',line:'LINE DRAWING',grid:'GRID SELECTOR',contact:'CONTACT REPORT',inspect:'INSPECT UNIT'})[mode]+'<span>'+({marker:'Choose a symbol, then click to place it',line:'Click start, then end · Right-click to cancel / delete',grid:'Click a location to attach its grid',contact:'Click the observed contact location',inspect:'Click a friendly symbol to view its roster'})[mode]+'</span>';
 if(mode==='marker'&&openMenu)editMapMarker(null,true);
 drawMap();
}
function handleMapPoint(p){
 state.selection=p;
 if(mapMode==='inspect'){
   const u=units.reduce((best,u)=>Math.hypot(u.x-p.x,u.y-p.y)<Math.hypot(best.x-p.x,best.y-p.y)?u:best,units[0]);
   if(Math.hypot(u.x-p.x,u.y-p.y)*worldTransform().s>26){toast('No friendly symbol here. Previous selection retained.');return}
   selected=u.id;renderRoster();drawMap();
   modal('Unit inspector',`<h3>${escapeHTML(u.name)}</h3><p>GRID ${grid(u)} · STATUS ${u.kind==='inf'?'READY':'MOVING'}</p><p>COMBAT: NOT IN COMBAT (simulated)</p><h4>TEAM MEMBERS / RANK</h4>${Array.from({length:u.kind==='air'?2:8},(_,i)=>`<p>${['SERGEANT','CORPORAL','PRIVATE'][Math.min(i,2)]} · Preview member ${i+1}</p>`).join('')}<p class="workspace-note">Fictional preview roster. The native inspector reads actual unit names, ranks and engine combat behaviour.</p>`,()=>{});$('#modal-submit').textContent='Close';return;
 }else if(mapMode==='contact'){openContactReport(p)}else if(mapMode==='marker'){
   if(pendingMapMarker){state.mapMarkers.push({...pendingMapMarker,x:p.x,y:p.y});pendingMapMarker=null;save();drawMap();toast('Marker placed at '+grid(p));return}
   const s=worldTransform().s;const existing=state.mapMarkers.find(m=>Math.hypot(m.x-p.x,m.y-p.y)*s<20);editMapMarker(existing||null);
 }else if(mapMode==='line'){
   if(!lineStart){lineStart=p;toast('Start selected. Click the end point.')}else{if(Math.hypot(lineStart.x-p.x,lineStart.y-p.y)>1){state.mapLines.push({id:Date.now(),points:[lineStart,p],colour:'ColorBlue'});save();toast('Line added')}lineStart=null}
 }else{save();toast('Grid selected: '+grid(p))}
 if($('#attached-grid'))$('#attached-grid').textContent=grid(p);
 drawMap();
}
$$('[data-map-mode]').forEach(b=>b.onclick=()=>setMapMode(b.dataset.mapMode));
$('#mark-button').onclick=()=>setMapMode('marker');
const baseDown=canvas.onpointerdown,baseMove=canvas.onpointermove,baseUp=canvas.onpointerup;
canvas.onpointerdown=e=>{mapPointer={x:e.clientX,y:e.clientY};if(mapMode==='grid')baseDown(e);else drag=null};
canvas.onpointermove=e=>{baseMove(e);const r=canvas.getBoundingClientRect();mapHover=toWorld(e.clientX-r.left,e.clientY-r.top);if(lineStart)drawMap()};
canvas.onpointerup=e=>{baseUp(e);if(e.button!==0||!mapPointer)return;const moved=Math.hypot(e.clientX-mapPointer.x,e.clientY-mapPointer.y);mapPointer=null;if(moved<5){const r=canvas.getBoundingClientRect();handleMapPoint(toWorld(e.clientX-r.left,e.clientY-r.top))}};
canvas.ondblclick=null;
canvas.oncontextmenu=e=>{if(mapMode!=='line')return;e.preventDefault();if(lineStart){lineStart=null;drawMap();toast('Line cancelled');return}const r=canvas.getBoundingClientRect(),p=toWorld(e.clientX-r.left,e.clientY-r.top),scale=worldTransform().s;const i=state.mapLines.findIndex(l=>{const [a,b]=l.points,vx=b.x-a.x,vy=b.y-a.y,len=vx*vx+vy*vy;if(!len)return false;const t=Math.max(0,Math.min(1,((p.x-a.x)*vx+(p.y-a.y)*vy)/len));return Math.hypot(p.x-a.x-t*vx,p.y-a.y-t*vy)*scale<12});if(i>=0){state.mapLines.splice(i,1);save();drawMap();toast('Line deleted')}};
const drawBeforeLines=drawMap;
drawMap=function(){drawBeforeLines();if(!canvas.clientWidth)return;const {s,tx,ty}=worldTransform(),dpr=Math.min(devicePixelRatio||1,2);ctx.setTransform(dpr,0,0,dpr,0,0);ctx.lineWidth=2;ctx.lineCap='round';const drawLine=(a,b,preview=false)=>{ctx.strokeStyle=preview?'#75cef8':'#52baff';ctx.setLineDash(preview?[6,5]:[]);ctx.beginPath();ctx.moveTo(a.x*s+tx,a.y*s+ty);ctx.lineTo(b.x*s+tx,b.y*s+ty);ctx.stroke();ctx.setLineDash([])};state.mapLines.forEach(l=>drawLine(...l.points));if(lineStart&&mapHover)drawLine(lineStart,mapHover,true)};
setMapMode('grid',false);

const renderBeforeChatKeys=renderPanel;
renderPanel=function(){renderBeforeChatKeys();if(tab==='messages'&&$('#message-text')){$('#message-text').addEventListener('keydown',e=>{if(e.key==='Enter'&&!e.shiftKey){e.preventDefault();$('#compose').requestSubmit()}});$$('.chat-message.own .chat-bubble').forEach(b=>{const sent=document.createElement('small');sent.className='chat-delivery';sent.textContent='Sent · local preview';b.append(sent)})}};
renderPanel();


