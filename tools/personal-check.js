// Sweep the Personal edition for work-related text on every screen, modal, help topic and change log.
const {chromium,devices}=require('playwright');
const BAN=/zoho|netsuite|exchange|outlook|customer|\bsales?\b|\bleads?\b|diamond|jewel|\btom\b|\bcrm\b|💼|💎|💰|\bwork\b|work contact|washington|prospect/i;
(async()=>{const b=await chromium.launch();const p=await (await b.newContext({...devices['iPad (gen 7)'],deviceScaleFactor:1})).newPage();
const errs=[];p.on('pageerror',e=>errs.push(e.message));
await p.goto('file://'+__dirname+'/pers/index.html');await p.waitForTimeout(800);
const hits0=[];for(const sec of ['book','prep','out']){await p.evaluate(s=>{UI.section=s;UI.tab='import';render()},sec);await p.waitForTimeout(250);const t=await p.evaluate(()=>document.body.innerText);t.split('\n').filter(l=>BAN.test(l)).forEach(l=>hits0.push('[empty '+sec+'] '+l.trim().slice(0,200)))}console.log(hits0.join('\n'));await p.evaluate(()=>{UI.section='prep';render()});
await p.setInputFiles('#fin',[__dirname+'/src2/addr.vcf',__dirname+'/src/many.csv']);await p.waitForTimeout(3000);
const hits=new Map();
const grab=async(where)=>{const t=await p.evaluate(()=>document.body.innerText);for(const line of t.split('\n')){const l=line.trim();if(l&&BAN.test(l)){const m=l.match(BAN);const i=Math.max(0,m.index-90);const k=l.slice(i,m.index+90);if(!hits.has(k))hits.set(k,where)}}};
const ev=async(f)=>{try{await p.evaluate(f)}catch(e){errs.push('eval '+e.message)}await p.waitForTimeout(250)};
const closeM=()=>ev(()=>{document.querySelectorAll('.modal.on,#modal.on').forEach(m=>m.classList.remove('on'))});
for(const adv of [false,true]){
  await ev(a=>{S.settings.advanced=a;render()},adv);
  await ev(()=>{UI.section='book';render()});await grab('book adv='+adv);
  for(const tab of ['import','compare','dupes','master']){await ev(t=>{UI.section='prep';UI.tab=t;render()},tab);await grab('prep '+tab+' adv='+adv)}
  await ev(()=>{UI.section='out';render()});await grab('export adv='+adv);
}
await ev(()=>{UI.section='book';render()});
for(const sel of ['#listbtn','[data-act=changelog]','[data-act=help]','[data-act=groups]','[data-act=settings]','[data-act=books]','[data-act=photos]','[data-act=arcview]']){
  const el=await p.$(sel);if(el&&await el.isVisible()){try{await el.click();await p.waitForTimeout(350);await grab('modal '+sel)}catch(e){errs.push(sel+' '+e.message)}await closeM()}else hits.set('(not found) '+sel,'-');
}
// a contact card and its edit page
await ev(()=>detail(MD.contacts[0].id));await grab('card');
const ed=await p.$('[data-act=edit]');if(ed&&await ed.isVisible()){await ed.click();await p.waitForTimeout(300);await grab('edit')}
await closeM();
// every help topic the Personal menu would show, plus the change log text
const txt=await p.evaluate(()=>{const strip=h=>String(h).replace(/<[^>]+>/g,' ').replace(/&[a-z]+;/g,' ');const out=[];
  const menu=document.createElement('div');menu.innerHTML=helpMenu('');out.push(['help menu',menu.innerText||menu.textContent]);
  for(const [g,items] of HELP)for(const it of items){if(menu.innerHTML.includes(`data-v="${it[0]}"`)||menu.innerHTML.includes(`'${it[0]}'`)||menu.textContent.includes(strip(it[1]).trim()))out.push(['help:'+it[0],strip(it[1])+' '+strip(it[2]||'')])}
  out.push(['changelog',CHANGELOG.map(x=>x[2].join(' ')).join(' ')]);return out});
for(const [w,t] of txt){for(const sentence of String(t).split(/(?<=[.!?])\s+|\n/)){const l=sentence.trim();if(l&&BAN.test(l)){const k=l.slice(0,180);if(!hits.has(k))hits.set(k,w)}}}
for(const [k,w] of hits)console.log('['+w+'] '+k);
console.log('hits',hits.size,'errs',errs);await b.close()})();
