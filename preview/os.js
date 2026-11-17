/* SynapseOS design companion. Device state and app registration mirror native APIs. */
const synapseApps=new Map();let synapseState='full',synapseLastApp='home';
const osHome=document.createElement('section');osHome.className='os-home';$('.workspace').before(osHome);
const customApp=document.createElement('section');customApp.className='os-custom-app';$('.workspace').before(customApp);
const gps=document.createElement('aside');gps.className='synapse-gps';gps.innerHTML='<div>ATLAS / MOVING GPS <span>Ctrl+U to maximize</span></div><canvas width="600" height="300"></canvas><small>SIMULATED POSITION / '+state.callsign+'</small>';document.body.append(gps);
function synapseRegisterApp(app){if(!app?.id||!app.name||typeof app.launch!=='function')throw Error('An app needs id, name and launch callback');synapseApps.set(app.id,app);renderOSHome();return true}
let synapseStart=false;
function renderOSHome(){
 const apps=[...synapseApps.values()];
 const trayIcon=(name,alt)=>`<img src="assets/taskbar-${name}.png" alt="${alt}">`;
 osHome.innerHTML=`<div class="os-app-grid">${apps.map(a=>`<button data-os-app="${escapeHTML(a.id)}"><img src="${escapeHTML(a.icon||'assets/atlas-glyph.png')}" alt=""><strong>${escapeHTML(a.name)}</strong></button>`).join('')}</div><div class="desktop-start-menu" ${synapseStart?'':'hidden'}><h3>Applications</h3>${apps.map(a=>`<button data-os-menu="${escapeHTML(a.id)}"><img src="${escapeHTML(a.icon||'assets/atlas-glyph.png')}" alt="">${escapeHTML(a.name)}</button>`).join('')}</div><div class="desktop-taskbar"><button id="desktop-start" title="Start / applications">${trayIcon('start','Start')}</button><button id="desktop-search" title="Find an application"><span>Search apps</span></button><button id="desktop-tasks" title="Applications">${trayIcon('taskview','Applications')}</button>${['ATLAS','SETTINGS','CAMERA'].map(id=>`<button data-os-pin="${id}" title="${id}"><img src="assets/${id.toLowerCase()}-app.png" alt="${id}"></button>`).join('')}<div class="desktop-tray"><span class="tray-chevron" title="System tray">⌃</span><span title="ATLAS data link">${trayIcon('network','Data link')}</span><span title="Notification audio">${trayIcon('volume','Notification audio')}</span><time>${new Date().toLocaleTimeString('en-GB',{hour:'2-digit',minute:'2-digit'})}<small>${new Date().toLocaleDateString('en-GB')}</small></time><span title="Notifications">${trayIcon('notifications','Notifications')}</span></div><span class="desktop-show-desktop" title="Desktop"></span></div>`;
 $$('.os-app-grid [data-os-app]').forEach(b=>b.onclick=()=>synapseLaunch(b.dataset.osApp));
 $$('.desktop-taskbar [data-os-pin]').forEach(b=>b.onclick=()=>synapseLaunch(b.dataset.osPin));
 $$('.desktop-start-menu [data-os-menu]').forEach(b=>b.onclick=()=>synapseLaunch(b.dataset.osMenu));
 $('#desktop-search').onclick=$('#desktop-tasks').onclick=()=>{synapseStart=true;renderOSHome()};
 $('#desktop-start').onclick=()=>{synapseStart=!synapseStart;renderOSHome()};
}
function synapseHome(){synapseState='full';synapseLastApp='home';synapseStart=false;document.body.dataset.osApp='home';document.body.dataset.deviceState='full';$('.brand').textContent='SynapseOS';$('.identity').innerHTML='DESKTOP<span>APPLICATIONS / FIELD SYSTEMS</span>';renderOSHome()}
function synapseLaunch(id){const app=synapseApps.get(id);if(!app)return false;synapseState='full';synapseLastApp=id;document.body.dataset.osApp=id;document.body.dataset.deviceState='full';$('.brand').textContent=id==='ATLAS'?'ATLAS':'SynapseOS';$('.identity').innerHTML=escapeHTML(id==='ATLAS'?'COMMON OPERATIONAL PICTURE':app.name)+'<span>SYNAPSEOS / FIELD SYSTEMS</span>';customApp.innerHTML='';app.launch(customApp);requestAnimationFrame(()=>drawMap());return true}
function synapseCycle(){if(synapseState==='full'){synapseState='mini';document.body.dataset.deviceState='mini'}else if(synapseState==='mini'){if(synapseLastApp==='home')synapseHome();else synapseLaunch(synapseLastApp)}else{synapseState='mini';document.body.dataset.deviceState='mini'}}
function synapsePower(){synapseState='closed';synapseLastApp='home';document.body.dataset.deviceState='closed'}
const osControls=document.createElement('div');osControls.className='os-device-controls';osControls.innerHTML='<button id="os-cycle">Device key / Ctrl+U</button><button id="os-home">Home</button><button id="os-power">Power</button>';deviceSelector.append(osControls);$('#os-cycle').onclick=synapseCycle;$('#os-home').onclick=synapseHome;$('#os-power').onclick=synapsePower;
let synapseRole='SECONDARY';
function synapseKeyAction(action){
 if(action==='MAIN'){if(synapseState==='mini'){synapseState='closed';document.body.dataset.deviceState='closed'}else{synapseState='mini';document.body.dataset.deviceState='mini'}return}
 if(action==='SECONDARY'||action==='TERTIARY'){
  if(synapseState==='full'&&synapseRole===action){synapseState='closed';document.body.dataset.deviceState='closed';return}
  if(action==='TERTIARY')setPreviewDevice('tablet');
  if(synapseLastApp==='home')synapseHome();else synapseLaunch(synapseLastApp);synapseRole=action;return;
 }
 if(action==='POSITION'){if(synapseState==='mini')gps.classList.toggle('gps-left');return}
 if(synapseState==='mini'){gps.dataset.zoom=String(Math.min(4,Math.max(.5,Number(gps.dataset.zoom||1)*(action==='IN'?2:.5))))}
 else if(synapseState==='full'&&synapseLastApp==='ATLAS'){zoom=Math.min(4,Math.max(.6,zoom*(action==='IN'?2:.5)));drawMap()}
}
document.addEventListener('keydown',e=>{
 if(e.target.matches('input,textarea,select')&&!e.ctrlKey&&!e.altKey)return;
 let action=null;
 if(e.code==='KeyU'&&!e.shiftKey)action=e.ctrlKey?'SECONDARY':e.altKey?'TERTIARY':'MAIN';
 if(e.ctrlKey&&e.shiftKey&&!e.altKey){if(e.code==='PageUp')action='IN';if(e.code==='PageDown')action='OUT';if(e.code==='Home')action='POSITION'}
 if(action){e.preventDefault();if(!e.repeat)synapseKeyAction(action)}
});
synapseRegisterApp({id:'ATLAS',name:'ATLAS',icon:'assets/atlas-glyph.png',launch:()=>{}});
synapseRegisterApp({id:'SETTINGS',name:'Settings',icon:'assets/settings-glyph.png',launch:root=>{
 const profile=JSON.parse(localStorage.getItem('atlas-operator-profile')||'null')||{callsign:state.callsign,role:'Rifleman',rank:'SERGEANT'};
 root.innerHTML=`<h2>Operator profile</h2><form id="profile-settings"><label>Personal callsign<input name="callsign" maxlength="32" required value="${escapeHTML(profile.callsign)}"></label><label>Role<input name="role" maxlength="32" required value="${escapeHTML(profile.role)}"></label><label>Display rank<select name="rank">${['PRIVATE','CORPORAL','SERGEANT','LIEUTENANT','CAPTAIN','MAJOR','COLONEL'].map(rank=>`<option ${rank===profile.rank?'selected':''}>${rank}</option>`).join('')}</select></label><p>Display rank does not change mission rank or command permissions.</p><button type="submit">Save profile</button><output id="profile-status"></output></form>`;
 root.querySelector('form').onsubmit=e=>{e.preventDefault();const data=Object.fromEntries(new FormData(e.target));data.callsign=data.callsign.trim();data.role=data.role.trim();if(!data.callsign||!data.role)return;localStorage.setItem('atlas-operator-profile',JSON.stringify(data));root.querySelector('output').textContent='Profile saved / offline preview';};
}});
window.SynapseOS={registerApp:synapseRegisterApp,launch:synapseLaunch,home:synapseHome,cycle:synapseCycle,power:synapsePower,keyAction:synapseKeyAction,get state(){return synapseState}};
setInterval(()=>{if(synapseState!=='mini')return;const c=gps.querySelector('canvas'),g=c.getContext('2d');g.fillStyle='#0b2228';g.fillRect(0,0,c.width,c.height);g.drawImage(terrain,150,350,600,300,0,0,600,300);g.strokeStyle='#91b9b066';for(let x=0;x<600;x+=75){g.beginPath();g.moveTo(x,0);g.lineTo(x,300);g.stroke()}for(let y=0;y<300;y+=75){g.beginPath();g.moveTo(0,y);g.lineTo(600,y);g.stroke()}g.fillStyle='#5ce4d1';g.beginPath();g.moveTo(300,134);g.lineTo(289,160);g.lineTo(311,160);g.closePath();g.fill()},500);
synapseHome();

// Device frame buttons share the native actions and artwork coordinates.
const hardware=document.createElement('div');hardware.className='hardware-controls';document.querySelector('.workstation').append(hardware);
const hardwareActions={HOME:()=>document.body.dataset.osApp==='home'?(synapseStart=!synapseStart,renderOSHome()):synapseHome(),POWER:synapsePower,ATLAS:()=>synapseLaunch('ATLAS'),MESSAGES:()=>{synapseLaunch('ATLAS');setTab('messages');setHandheldPane('app')},IN:()=>{synapseLaunch('ATLAS');setTab('overview');setHandheldPane('map');document.querySelector('#zoom-in').click()},OUT:()=>{synapseLaunch('ATLAS');setTab('overview');setHandheldPane('map');document.querySelector('#zoom-out').click()}};
function renderHardware(){
 const phone=['phone','portable'].includes(document.body.dataset.device);
 const buttons=phone?[['ATLAS','20.5,0.8,12.5,4.8','ATLAS shortcut'],['OUT','35.4,1.6,7.3,3.6','Map zoom out'],['IN','44.8,1.6,7.3,3.6','Map zoom in'],['HOME','44,93.2,11.5,5.5','Home / Start'],['POWER','96.8,32.5,2.8,37','Power off'],['MESSAGES','0.4,32.5,2.5,37','Messages shortcut']]:[['HOME','13.3,88.2,4.9,5','Home / Start'],['OUT','18.7,88.2,4.9,5','Map zoom out'],['IN','24,88.2,4.9,5','Map zoom in'],['POWER','79.5,88.2,5.3,5','Power off']];
 hardware.innerHTML=buttons.map(([action,rect,label])=>{const [x,y,w,h]=rect.split(',');return `<button data-hardware="${action}" title="${label}" aria-label="${label}" style="left:${x}%;top:${y}%;width:${w}%;height:${h}%"></button>`}).join('');
 hardware.querySelectorAll('button').forEach(b=>b.onclick=hardwareActions[b.dataset.hardware]);
}
new MutationObserver(renderHardware).observe(document.body,{attributes:true,attributeFilter:['data-device']});renderHardware();

