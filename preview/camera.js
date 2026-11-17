/* Design companion only: photographs here depict the fictional preview terrain. */
const previewPhotos=[];let previewPhoto=null;
synapseRegisterApp({id:'CAMERA',name:'Camera',icon:'assets/camera-glyph.png',launch:root=>{
 root.innerHTML='<h2>Camera</h2><p class="workspace-note">SIMULATED SCENE / DESIGN PREVIEW</p><canvas id="photo-camera" width="512" height="256"></canvas><form id="photo-capture"><label>Caption<input name="caption" maxlength="80" value="Field photograph" required></label><button>Snap picture</button></form><div id="photo-gallery"></div>';
 const camera=root.querySelector('canvas'),g=camera.getContext('2d');g.drawImage(terrain,150,350,600,300,0,0,512,256);
 const gallery=()=>{root.querySelector('#photo-gallery').innerHTML=previewPhotos.map((p,i)=>`<button data-photo="${i}"><img src="${p.image}" alt="${escapeHTML(p.caption)}"><span>${escapeHTML(p.caption)}</span></button>`).join('');root.querySelectorAll('[data-photo]').forEach(b=>b.onclick=()=>{previewPhoto=previewPhotos[Number(b.dataset.photo)];const attach=document.createElement('button');attach.id='photo-attach';attach.textContent='Attach to report';attach.onclick=()=>{SynapseOS.launch('ATLAS');setTab('reports');renderPanel()};root.querySelector('#photo-attach')?.remove();root.append(attach)})};
 root.querySelector('form').onsubmit=e=>{e.preventDefault();const caption=new FormData(e.target).get('caption').trim();if(!caption)return;previewPhotos.push({caption,image:camera.toDataURL('image/jpeg',.65)});gallery()};gallery();
}});
const panelBeforePhotos=renderPanel;
renderPanel=function(){panelBeforePhotos();if(tab!=='reports')return;
 const form=document.querySelector('#compose');
 if(previewPhoto){const figure=document.createElement('figure');figure.className='report-photo';figure.innerHTML=`<img src="${previewPhoto.image}" alt="Attached preview photograph"><figcaption>${escapeHTML(previewPhoto.caption)}</figcaption>`;form?.prepend(figure)}
 if(form){const submit=form.onsubmit;form.onsubmit=e=>{const photo=previewPhoto;submit?.call(form,e);if(photo&&state.reports.length){state.reports.at(-1).photo=photo;previewPhoto=null;save();renderPanel()}}}
 for(const p of document.querySelectorAll('#primary-panel .log-item')){const report=state.reports.find(r=>p.textContent.includes(r.text));if(report?.photo){const img=document.createElement('img');img.className='report-photo-image';img.alt=report.photo.caption;img.src=report.photo.image;p.append(img)}}
};
