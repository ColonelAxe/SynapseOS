import {spawn} from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import {pathToFileURL} from 'node:url';
import assert from 'node:assert/strict';
const root=path.resolve(import.meta.dirname,'..');
const edge=process.env.SICS_BROWSER || 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
const profile=await fs.mkdtemp(path.join(os.tmpdir(),'sics-check-'));
const browser=spawn(edge,['--headless','--disable-gpu','--no-first-run','--no-default-browser-check',`--user-data-dir=${profile}`,'--remote-debugging-port=0','about:blank'],{stdio:'ignore',windowsHide:true});
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
let ws;const pending=new Map();let serial=0;const errors=[];
try{
 let port;
 for(let i=0;i<100;i++){try{port=Number((await fs.readFile(path.join(profile,'DevToolsActivePort'),'utf8')).split('\n')[0]);break}catch{await sleep(100)}}
 assert.ok(port,'Headless browser must start');
 const targets=await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
 ws=new WebSocket(targets.find(t=>t.type==='page').webSocketDebuggerUrl);
 await new Promise((r,j)=>{ws.onopen=r;ws.onerror=j});
 ws.onmessage=e=>{const m=JSON.parse(e.data);if(m.id){const p=pending.get(m.id);if(p){pending.delete(m.id);m.error?p.reject(m.error):p.resolve(m.result)}}if(m.method==='Runtime.exceptionThrown')errors.push(m.params.exceptionDetails.text)};
 function send(method,params={}){return new Promise((resolve,reject)=>{const id=++serial;pending.set(id,{resolve,reject});ws.send(JSON.stringify({id,method,params}));setTimeout(()=>{if(pending.has(id)){pending.delete(id);reject(new Error('CDP timeout: '+method))}},12000).unref()})}
 async function evaluate(expression){const r=await send('Runtime.evaluate',{expression,returnByValue:true,awaitPromise:true});if(r.exceptionDetails)throw new Error(JSON.stringify(r.exceptionDetails));return r.result.value}
 await send('Runtime.enable');await send('Page.enable');
 await send('Emulation.setDeviceMetricsOverride',{width:1600,height:1000,deviceScaleFactor:1,mobile:false});
 await send('Page.navigate',{url:pathToFileURL(path.join(root,'preview/index.html')).href});
 for(let i=0;i<100;i++){if(await evaluate("document.querySelectorAll('[data-unit]').length===6"))break;await sleep(100)}
 assert.equal(await evaluate("document.querySelectorAll('[data-unit]').length"),6,'force roster');
 assert.equal(await evaluate('document.body.dataset.osApp'),'home','SynapseOS starts at launcher');
 assert.equal(await evaluate("document.querySelectorAll('[data-os-app=ATLAS]').length"),1,'ATLAS application icon');
 assert.ok(await evaluate("document.querySelector('[data-os-app=ATLAS] img').src.endsWith('atlas-glyph.png')"),'app-style ATLAS artwork');
 await evaluate("SynapseOS.launch('SETTINGS');document.querySelector('#profile-settings [name=callsign]').value='ALPHA 2';document.querySelector('#profile-settings [name=role]').value='JTAC';document.querySelector('#profile-settings').requestSubmit()");
 assert.equal(await evaluate("JSON.parse(localStorage.getItem('atlas-operator-profile')).role"),'JTAC','settings profile saved');
 await evaluate('SynapseOS.home()');
 await evaluate("SynapseOS.launch('CAMERA');document.querySelector('#photo-capture').requestSubmit();document.querySelector('[data-photo]').click();document.querySelector('#photo-attach').click();document.querySelector('#message-text').value='Photographic contact report';document.querySelector('#compose').requestSubmit()");
 assert.ok(await evaluate("state.reports.at(-1).photo.image.startsWith('data:image/jpeg')"),'Camera photo attached to report');
 await evaluate("state.reports.pop();save();previewPhoto=null;SynapseOS.home()");
 await evaluate("SynapseOS.launch('ATLAS');setPreviewDevice('tablet')");
 assert.ok(await evaluate("document.querySelector('#tactical-map').width>0"),'map drawn');
 await evaluate("document.querySelector('[data-map-mode=marker]').click();document.querySelector('#marker-label').value='CHECKPOINT ECHO';document.querySelector('#modal-submit').click();handleMapPoint({x:420,y:340})");
 assert.equal(await evaluate("state.mapMarkers[0].text"),'CHECKPOINT ECHO','map marker creation');
 await evaluate("editMapMarker(state.mapMarkers[0]);document.querySelector('#marker-colour').value='ColorRed';document.querySelector('#modal-submit').click()");
 assert.equal(await evaluate("state.mapMarkers[0].colour"),'ColorRed','map marker editing');
 await evaluate("editMapMarker(state.mapMarkers[0]);document.querySelector('#delete-map-marker').click()");
 assert.equal(await evaluate('state.mapMarkers.length'),0,'map marker deletion');
 await evaluate("document.querySelector('[data-map-mode=line]').click();handleMapPoint({x:100,y:200});handleMapPoint({x:300,y:400})");
 assert.equal(await evaluate('state.mapLines.length'),1,'line drawing');
 await evaluate("document.querySelector('[data-map-mode=grid]').click();handleMapPoint({x:250,y:350})");
 assert.equal(await evaluate('state.selection.x'),250,'grid selector');
 assert.equal(await evaluate("document.querySelector('#modal').open"),false,'grid selector does not open marker menu');
 await evaluate("document.querySelector('[data-tab=reports]').click();document.querySelector('#mark-contact').click();handleMapPoint({x:610,y:530});document.querySelector('#contact-affiliation').value='OPFOR';document.querySelector('#contact-type').value='Armoured vehicle';document.querySelector('#contact-symbol').value='armor';document.querySelector('#contact-details').value='Two IFVs moving north';document.querySelector('#modal-submit').click()");
 assert.equal(await evaluate("state.reports.at(-1).symbol"),'o_armor','contact affiliation and NATO symbol');
 assert.equal(await evaluate("state.reports.at(-1).category"),'Armoured vehicle','contact type');
 assert.equal(await evaluate('state.reports.at(-1).designation'),'CONTACT','contact designation');
 assert.equal(await evaluate('state.reports.at(-1).strength'),1,'contact strength');
 await evaluate("receivePreviewEvent({id:99101,kind:'messages',from:'BRAVO 1-2',text:'Incoming notification test'})");
 assert.equal(await evaluate('notices.length'),1,'incoming event notification');
 assert.equal(await evaluate('lastPreviewSoundRequested'),'message','incoming voice cue');
 await evaluate("receivePreviewEvent({id:99101,kind:'messages',from:'BRAVO 1-2',text:'Incoming notification test'})");
 assert.equal(await evaluate('notices.length'),1,'notification deduplication');
 await evaluate("receivePreviewEvent({id:99102,kind:'messages',from:state.callsign,text:'Own event'})");
 assert.equal(await evaluate('notices.length'),1,'own event notification suppression');
 assert.ok(await evaluate("selected='bravo';pan={x:400,y:-250};centrePreview();(()=>{const u=uiUnit(),t=worldTransform();return Math.abs(u.x*t.s+t.tx-t.w/2)<1&&Math.abs(u.y*t.s+t.ty-t.h/2)<1})()"),'centre selected after panning away');
 await evaluate("selected='alpha';renderRoster()");
 await evaluate("setMapMode('inspect');handleMapPoint({...units.find(u=>u.id==='bravo')})");
 assert.equal(await evaluate('selected'),'bravo','inspect selects clicked friendly');
 assert.ok(await evaluate("document.querySelector('#modal').textContent.includes('TEAM MEMBERS / RANK')"),'inspector roster and ranks');
 await evaluate("document.querySelector('#modal-submit').click();setMapMode('grid');selected='alpha';renderRoster()");
 await evaluate("document.querySelector('#callsign-button').click();document.querySelector('#new-callsign').value='ATLAS ACTUAL';document.querySelector('#modal-submit').click()");
 assert.equal(await evaluate("document.querySelector('#own-callsign').textContent"),'ATLAS ACTUAL','callsign edit');
 await evaluate("document.querySelector('[data-tab=messages]').click();document.querySelector('#message-text').value='Browser smoke test transmission';document.querySelector('#compose').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('#primary-panel').textContent.includes('Browser smoke test transmission')"),'message submission');
 await evaluate("document.querySelector('#create-channel').click();document.querySelector('#channel-name').value='Ground to Air';document.querySelector('#channel-type').value='GROUND-AIR';document.querySelector('input[name=groups][value=eagle]').checked=true;document.querySelector('#modal-submit').click()");
 assert.equal(await evaluate('state.channels.at(-1).type'),'GROUND-AIR','custom channel type');
 assert.ok(await evaluate("canPreviewChannel(state.channels.at(-1),'eagle')&&!canPreviewChannel(state.channels.at(-1),'bravo')"),'channel group access policy');
 await evaluate("document.querySelector('#channel-message').value='Air support channel test';document.querySelector('#channel-compose').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('#primary-panel').textContent.includes('Air support channel test')"),'custom channel message');
 await evaluate("document.querySelector('#manage-channel').click();document.querySelector('input[name=groups][value=eagle]').checked=false;document.querySelector('input[name=managers][value=alpha]').checked=true;document.querySelector('#modal-submit').click()");
 assert.ok(await evaluate("!canPreviewChannel(state.channels.at(-1),'eagle')&&canPreviewChannel(state.channels.at(-1),'alpha',true)"),'channel revoke and manager roles');
 await evaluate("selected='alpha';renderRoster();renderPanel()");
 assert.equal(await evaluate("document.querySelector('#primary-panel').textContent.includes('Air support channel test')"),false,'private channel history isolation');
 await evaluate("selected=state.channels.at(-1).id;renderRoster();renderPanel();document.querySelector('#manage-channel').click();document.querySelector('#delete-channel').click()");
 assert.equal(await evaluate('state.channels.length'),1,'delete requires confirmation');
 await evaluate("document.querySelector('#delete-channel').click()");
 assert.equal(await evaluate('state.channels.length'),0,'delete channel');
 assert.equal(await evaluate('state.channelMessages.length'),0,'delete channel history');
 await evaluate("document.querySelector('[data-tab=c2]').click();document.querySelector('#order-title').value='Move to selected grid';document.querySelector('#message-text').value='Test order';document.querySelector('#compose').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('#primary-panel').textContent.includes('Move to selected grid')"),'order submission');
 await evaluate("document.querySelector('.ack.pending').click()");
 assert.equal(await evaluate("document.querySelectorAll('.ack.pending').length"),1,'acknowledgement updates one pending order');
 await evaluate("document.querySelector('[data-tab=reports]').click();document.querySelector('#message-text').value='Test SALUTE report';document.querySelector('#compose').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('#primary-panel').textContent.includes('Test SALUTE report')"),'report submission');
 await evaluate("document.querySelector('[data-tab=toc]').click();document.querySelector('#toc-name').value='TOC TEST';document.querySelector('#toc-form').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('.toc-status').textContent.includes('TOC TEST')"),'TOC configuration');
 await evaluate("document.querySelector('[data-tab=isr]').click();document.querySelector('#sensor-form').requestSubmit()");
 assert.ok(await evaluate("document.querySelector('#toast').textContent.includes('sensor linked')"),'ISR link');
 await evaluate("document.querySelector('#layers-button').click()");
 assert.equal(await evaluate("document.querySelector('#layers').classList.contains('hidden')"),false,'layer controls');
 const before=await evaluate('zoom');await evaluate("document.querySelector('#zoom-in').click()");assert.ok(await evaluate('zoom')>before,'map zoom');
 await evaluate("document.querySelector('#search').value='BRAVO';document.querySelector('#search').dispatchEvent(new Event('input'))");
 assert.equal(await evaluate("document.querySelectorAll('[data-unit]').length"),1,'roster search');
 await evaluate("document.querySelector('#search').value='';renderRoster();setPreviewDevice('phone');setTab('messages');selected='alpha';renderPanel();document.querySelector('#message-text').value='OS preserved browser draft';SynapseOS.cycle()");
 assert.equal(await evaluate('SynapseOS.state'),'mini','single-key minimize');
 await evaluate('SynapseOS.cycle()');
 assert.equal(await evaluate("document.querySelector('#message-text').value"),'OS preserved browser draft','minimize preserves draft');
 await evaluate("SynapseOS.home();SynapseOS.registerApp({id:'TOOLS',name:'Tools',launch:root=>root.textContent='Independent app'});SynapseOS.launch('TOOLS')");
 assert.equal(await evaluate("document.querySelector('.os-custom-app').textContent"),'Independent app','OS extension app');
 await evaluate("synapseApps.delete('TOOLS')");
 await evaluate("SynapseOS.power();SynapseOS.cycle()");
 assert.equal(await evaluate('SynapseOS.state'),'mini','closed opens moving GPS');
 await evaluate('SynapseOS.cycle()');
 assert.equal(await evaluate('document.body.dataset.osApp'),'home','GPS maximizes to launcher');
 const osShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-synapseos.png'),Buffer.from(osShot.data,'base64'));
 await evaluate("SynapseOS.launch('ATLAS');setTab('overview');setHandheldPane('map')");
 assert.ok(await evaluate("document.querySelector('#tactical-map').clientWidth>200"),'landscape handset map');
 const phoneShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-jtac.png'),Buffer.from(phoneShot.data,'base64'));
 // Return to a clean seed state before producing the delivered visual reference.
 await evaluate("localStorage.removeItem('sics-preview-v1')");await send('Page.reload');await sleep(500);
 await evaluate("SynapseOS.launch('ATLAS');setPreviewDevice('tablet')");
 const shot=await send('Page.captureScreenshot',{format:'png'});await fs.mkdir(path.join(root,'docs'),{recursive:true});await fs.writeFile(path.join(root,'docs/sics-interface.png'),Buffer.from(shot.data,'base64'));
 for(const view of ['c2','messages']){
   await evaluate(`document.querySelector('[data-tab=${view}]').click()`);await sleep(150);
   const viewShot=await send('Page.captureScreenshot',{format:'png'});
   await fs.writeFile(path.join(root,`docs/sics-${view}-redesign.png`),Buffer.from(viewShot.data,'base64'));
   for(const width of [1280,900,600,390]){await send('Emulation.setDeviceMetricsOverride',{width,height:1000,deviceScaleFactor:1,mobile:false});await sleep(100);assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`no ${view} overflow at ${width}px`)}
   await send('Emulation.setDeviceMetricsOverride',{width:1600,height:1000,deviceScaleFactor:1,mobile:false});
 }
 await evaluate("document.querySelector('[data-tab=overview]').click()");
 for(const width of [1280,900,600,390]){await send('Emulation.setDeviceMetricsOverride',{width,height:1000,deviceScaleFactor:1,mobile:false});await sleep(100);assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`no page overflow at ${width}px`)}
 for(const device of ['tablet','phone','portable','vehicle']){
  await evaluate(`setPreviewDevice('${device}')`);
  for(const width of [1600,900,600,390]){
   await send('Emulation.setDeviceMetricsOverride',{width,height:1000,deviceScaleFactor:1,mobile:false});
   for(const app of ['home','SETTINGS','CAMERA','NOTIFICATIONS']){
    await evaluate(app==='home'?'SynapseOS.home()':`SynapseOS.launch('${app}')`);await sleep(50);
    assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`${device}/${app} fits ${width}px`);
    if(app==='home')assert.ok(await evaluate("(()=>{const bar=document.querySelector('.desktop-taskbar').getBoundingClientRect();return [...document.querySelectorAll('.desktop-taskbar>button,.desktop-tray')].filter(e=>e.getBoundingClientRect().width).every(e=>e.getBoundingClientRect().right<=bar.right+1)})()"),`${device} taskbar fits ${width}px`);
    if(app==='SETTINGS'){
     await evaluate("document.querySelector('[data-settings-section=PREFERENCES]').click();document.querySelector('#beta-text-size').value='1.15';document.querySelector('#beta-text-size').dispatchEvent(new Event('change'))");
     assert.equal(await evaluate('betaPrefs.text'),1.15,'large text preference');
     assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`${device}/PREFERENCES fits ${width}px`);
    }
   }
   for(const page of ['overview','messages','c2','reports','isr','toc']){
    await evaluate(`SynapseOS.launch('ATLAS');setTab('${page}');setHandheldPane('${page==='overview'?'map':'app'}')`);await sleep(30);
    assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`${device}/ATLAS/${page} fits ${width}px`);
   }
  }
 }
 await send('Emulation.setDeviceMetricsOverride',{width:1600,height:1000,deviceScaleFactor:1,mobile:false});
 await evaluate("setPreviewDevice('tablet');SynapseOS.launch('ATLAS')");await sleep(50);
 await evaluate("document.querySelector('[data-hardware=HOME]').click()");
 assert.equal(await evaluate('document.body.dataset.osApp'),'home','physical Home button');
 await evaluate("document.querySelector('[data-hardware=HOME]').click()");
 assert.equal(await evaluate("document.querySelector('.desktop-start-menu').hidden"),false,'physical menu opens Start');
 await evaluate("document.querySelector('[data-hardware=IN]').click()");
 assert.equal(await evaluate('document.body.dataset.osApp'),'ATLAS','physical zoom opens map');
 await evaluate("document.querySelector('[data-hardware=POWER]').click()");
 assert.equal(await evaluate('SynapseOS.state'),'closed','physical Power button');
 await evaluate('SynapseOS.home()');
 await evaluate("betaPrefs.text=1;saveBetaPrefs();SynapseOS.launch('NOTIFICATIONS');receivePreviewEvent({id:99301,kind:'reports',from:'BRAVO 1-2',text:'Beta centre integration'});document.querySelector('.notice-row').click()");
 assert.ok(await evaluate("document.querySelector('.notice-detail').textContent.includes('Beta centre integration')"),'notification detail');
 const noticeShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-beta-notifications.png'),Buffer.from(noticeShot.data,'base64'));
 await evaluate("document.querySelector('#notice-open').click()");
 assert.equal(await evaluate('tab'),'reports','notification opens relevant page');
 await evaluate("SynapseOS.launch('NOTIFICATIONS');document.querySelector('#notice-clear').click()");
 assert.equal(await evaluate('notices.length'),0,'notification history clear');
 await evaluate("SynapseOS.launch('SETTINGS');document.querySelector('[data-settings-section=PREFERENCES]').click()");
 const prefShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-beta-preferences.png'),Buffer.from(prefShot.data,'base64'));
 await evaluate('SynapseOS.home()');
 const desktopShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-desktop-taskbar.png'),Buffer.from(desktopShot.data,'base64'));
 await evaluate("SynapseOS.launch('OPERATIONS')");
 assert.equal(await evaluate("!!document.querySelector('#ops-map')"),true,'Operations app opens');
 for(const section of ['PLANS','CONTACTS','ORDERS','SUPPORT','AIR','JOURNAL','PRESETS']){
  await evaluate(`document.querySelector('[data-ops-tab=${section}]').click()`);
  assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`Operations ${section} fits`);
 }
 await evaluate("opsDemo.tab='PLANS';renderOperations(customApp);opsEdit('PLAN');document.querySelector('#ops-title').value='Browser test overlay';document.querySelector('#modal-submit').click()");
 assert.ok(await evaluate("opsDemo.items.some(i=>i.kind==='PLAN'&&i.title==='Browser test overlay')"),'Operations overlay form saves');
 await evaluate("opsDemo.points=[{x:150,y:150},{x:350,y:210}];opsEdit('GRAPHIC');document.querySelector('#ops-title').value='Browser test route';document.querySelector('[data-ops-field=plan]').value='Browser test overlay';document.querySelector('#modal-submit').click()");
 assert.ok(await evaluate("opsDemo.items.some(i=>i.kind==='GRAPHIC'&&i.points.length===2)"),'Operations route form saves geometry');
 await evaluate("renderOperations(customApp);document.querySelector('#ops-follow').click()");
 assert.ok(await evaluate('opsDemo.following.length>0'),'Operations route following');
 const operationsShot=await send('Page.captureScreenshot',{format:'png'});await fs.writeFile(path.join(root,'docs/atlas-operations.png'),Buffer.from(operationsShot.data,'base64'));
 for(const width of [1600,900,600]){
  await send('Emulation.setDeviceMetricsOverride',{width,height:1000,deviceScaleFactor:1,mobile:false});
  await evaluate("setPreviewDevice('phone');SynapseOS.launch('OPERATIONS')");await sleep(50);
  assert.ok(await evaluate('document.documentElement.scrollWidth<=innerWidth+1'),`Operations fits ${width}px`);
 }
 assert.deepEqual(errors,[],'no uncaught browser errors');
 console.log('PASS: roster, map rendering, callsign, messages, orders, ACK, reports, TOC, ISR, layers, zoom, search, responsive layouts; no browser exceptions.');
} finally {if(ws)ws.close();browser.kill();}
