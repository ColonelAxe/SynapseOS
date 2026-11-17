/* Closed-beta design companion: native behavior lives in the SQF addon. */
const betaDefaults={voice:true,banners:true,text:1,trails:true,labels:true};
let betaPrefs;try{betaPrefs={...betaDefaults,...JSON.parse(localStorage.getItem('atlas-presentation')||'{}')}}catch{betaPrefs={...betaDefaults}}
window.ATLAS_previewPrefs=betaPrefs;
function saveBetaPrefs(){localStorage.setItem('atlas-presentation',JSON.stringify(betaPrefs));document.documentElement.style.setProperty('--atlas-text-scale',betaPrefs.text)}
saveBetaPrefs();
synapseRegisterApp({id:'NOTIFICATIONS',name:'Notifications',icon:'assets/notifications-glyph.png',launch:root=>{
 root.innerHTML='<h2>Notification centre</h2><p class="workspace-note">Latest 50 updates / This mission session</p><div class="notice-workspace"><div class="notice-items"></div><section class="notice-detail"><h3>You’re up to date</h3><p>Select an update to read its details.</p></section></div><div class="notice-actions"><button id="notice-read">Mark all read</button><button id="notice-clear">Clear history</button></div>';
 const list=root.querySelector('.notice-items');
 for(const n of notices.slice().reverse()){
  const b=document.createElement('button');b.className='notice-row';b.innerHTML=`<span class="notice-kind">${escapeHTML(n.title)}</span><strong>${escapeHTML(n.from)}</strong><span>${escapeHTML(n.text)}</span>`;
  b.onclick=()=>{list.querySelectorAll('button').forEach(x=>x.classList.toggle('selected',x===b));const detail=root.querySelector('.notice-detail');detail.innerHTML=`<h3>${escapeHTML(n.title)}</h3><small>${escapeHTML(n.from)}</small><p>${escapeHTML(n.text)}</p><button class="accent" id="notice-open">Open in ATLAS</button>`;detail.querySelector('button').onclick=()=>{n.read=true;synapseLaunch('ATLAS');setTab(n.tab);setHandheldPane('app')}};list.append(b);
 }
 if(!notices.length)list.innerHTML='<p class="notification-empty">No new updates.</p>';
 root.querySelector('#notice-read').onclick=()=>{notices.forEach(n=>n.read=true);Object.keys(unread).forEach(k=>unread[k]=0);renderNotices();synapseLaunch('NOTIFICATIONS')};
 root.querySelector('#notice-clear').onclick=()=>{notices.length=0;Object.keys(unread).forEach(k=>unread[k]=0);renderNotices();synapseLaunch('NOTIFICATIONS')};
}});
const profileLaunch=synapseApps.get('SETTINGS').launch;
function launchBetaSettings(root,section='PROFILE'){
 root.innerHTML='<div class="settings-tabs"><button data-settings-section="PROFILE">Operator profile</button><button data-settings-section="PREFERENCES">Preferences</button></div><div class="settings-content"></div>';
 root.querySelectorAll('[data-settings-section]').forEach(b=>{b.classList.toggle('selected',b.dataset.settingsSection===section);b.onclick=()=>launchBetaSettings(root,b.dataset.settingsSection)});
 const content=root.querySelector('.settings-content');if(section==='PROFILE'){profileLaunch(content);return}
 content.innerHTML=`<h2>Display & notifications</h2><div class="preference-grid">${[['voice','Spoken notification cues'],['banners','Incoming alert banners'],['trails','Vehicle movement trails'],['labels','Supplemental track labels']].map(([key,title])=>`<label>${title}<input type="checkbox" data-pref="${key}" ${betaPrefs[key]?'checked':''}></label>`).join('')}<label>Text size<select id="beta-text-size"><option value="0.9">Compact</option><option value="1">Standard</option><option value="1.15">Large</option></select></label></div><p class="workspace-note">Local display preferences. NATO symbols and equipment eligibility remain mission-controlled.</p><div class="notice-actions"><button id="beta-diagnostics">Show preview diagnostics</button><button id="preferences-notices">Notification centre</button></div><pre id="beta-diagnostic-output" hidden></pre>`;
 content.querySelectorAll('[data-pref]').forEach(e=>e.onchange=()=>{betaPrefs[e.dataset.pref]=e.checked;saveBetaPrefs()});
 content.querySelector('#beta-text-size').value=String(betaPrefs.text);content.querySelector('#beta-text-size').onchange=e=>{betaPrefs.text=Number(e.target.value);saveBetaPrefs()};
 content.querySelector('#preferences-notices').onclick=()=>synapseLaunch('NOTIFICATIONS');
 content.querySelector('#beta-diagnostics').onclick=()=>{const out=content.querySelector('pre');out.hidden=false;out.textContent=`ATLAS 0.12.0-beta.2\nDESIGN PREVIEW / Fictional data\nDevice: ${document.body.dataset.device}\nViewport: ${innerWidth} × ${innerHeight}\nNotifications: ${notices.length}`};
}
synapseApps.get('SETTINGS').launch=root=>launchBetaSettings(root);
const beforeBetaIncoming=receivePreviewEvent;
receivePreviewEvent=function(event){beforeBetaIncoming(event);if(document.body.dataset.osApp==='NOTIFICATIONS')synapseLaunch('NOTIFICATIONS')};
bell.innerHTML='<img src="assets/notifications-glyph.png" alt=""><span id="notification-count" hidden>0</span>';bell.onclick=()=>synapseLaunch('NOTIFICATIONS');
document.addEventListener('click',e=>{
 const tray=e.target.closest('.desktop-tray>span');if(!tray)return;
 if(tray===tray.parentElement.lastElementChild)synapseLaunch('NOTIFICATIONS');
 else if(tray.title==='Notification audio'){synapseLaunch('SETTINGS');launchBetaSettings(customApp,'PREFERENCES')}
});
