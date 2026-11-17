// Device preview selector. Native availability follows cTab gear/vehicle seats.
const deviceSelector=document.createElement('section');deviceSelector.className='device-selector';deviceSelector.innerHTML='<label>ATLAS FIELD SYSTEMS <select id="preview-device"><option value="tablet">Rugged tablet</option><option value="phone">JTAC handset (landscape)</option><option value="portable">Portable handheld</option><option value="vehicle">Mounted vehicle console</option></select></label><small>DEVICE DESIGN PREVIEW / FICTIONAL OPERATIONAL DATA</small>';
$('.workstation').before(deviceSelector);
const handheldPanes=document.createElement('div');handheldPanes.className='handheld-panes';handheldPanes.innerHTML='<button data-handheld-pane="map">Map</button><button data-handheld-pane="app">Workspace</button><button data-handheld-pane="units">Units / Chats</button>';$('nav').after(handheldPanes);
function setHandheldPane(pane){document.body.dataset.handheldPane=pane;$$('[data-handheld-pane]').filter(el=>el.tagName==='BUTTON').forEach(b=>b.classList.toggle('active',b.dataset.handheldPane===pane));drawMap()}
function setPreviewDevice(mode){document.body.dataset.device=mode;$('#preview-device').value=mode;$('.tablet-caption').textContent='ATLAS / '+({tablet:'RUGGED FIELD TABLET',phone:'RUGGED SMARTPHONE',portable:'PORTABLE HANDHELD',vehicle:'MOUNTED C2 CONSOLE'})[mode];setHandheldPane(tab==='overview'?'map':'app');requestAnimationFrame(()=>drawMap())}
$('#preview-device').onchange=e=>setPreviewDevice(e.target.value);$$('.handheld-panes button').forEach(b=>b.onclick=()=>setHandheldPane(b.dataset.handheldPane));
const setTabBeforeDevices=setTab;setTab=function(next){setTabBeforeDevices(next);if(['phone','portable'].includes(document.body.dataset.device))setHandheldPane(next==='overview'?'map':'app')};
const mapModeBeforeDevices=setMapMode;setMapMode=function(mode,openMenu=true){if(['phone','portable'].includes(document.body.dataset.device))setHandheldPane('map');mapModeBeforeDevices(mode,openMenu)};
setPreviewDevice('phone');


