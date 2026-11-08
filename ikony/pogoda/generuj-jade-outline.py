#!/usr/bin/env python3
# Rysuje konturowy zestaw ikon pogody jade-outline. Uzycie: generuj-jade-outline.py KATALOG_DOCELOWY
import sys,os,math,tempfile,gi
gi.require_version('GdkPixbuf','2.0')
from gi.repository import GdkPixbuf
T=sys.argv[1]; C='#dfede5'; SW=1.5
CLOUD='M7.2 18.5a4.2 4.2 0 0 1-.7-8.34A5.7 5.7 0 0 1 17.5 9a4.8 4.8 0 0 1-.2 9.5z'
def cloud(dy=0): return f'<path transform="translate(0 {dy})" d="{CLOUD}"/>'
def rays(cx,cy,r1,r2,n=8):
    o=''
    for i in range(n):
        a=2*math.pi*i/n
        o+=f'<line x1="{cx+r1*math.cos(a):.2f}" y1="{cy+r1*math.sin(a):.2f}" x2="{cx+r2*math.cos(a):.2f}" y2="{cy+r2*math.sin(a):.2f}"/>'
    return o
def sun_big(): return f'<circle cx="12" cy="12" r="4.2"/>'+rays(12,12,7,9.6)
def moon_big(): return '<path d="M19.5 14.6A8.2 8.2 0 1 1 9.4 4.5a6.8 6.8 0 0 0 10.1 10.1z"/>'
def small(kind,dy):
    # male slonce/ksiezyc za chmura: zasloniete maska o ksztalcie chmury
    if kind=='sun': g=f'<circle cx="8" cy="7.6" r="2.8"/>'+rays(8,7.6,4.6,6.4)
    else: g='<path d="M11.2 8.9A4.4 4.4 0 1 1 6.2 3.6a3.6 3.6 0 0 0 5 5.3z"/>'
    return f'<mask id="m" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24"><rect width="24" height="24" fill="#fff"/><path transform="translate(0 {dy})" d="{CLOUD}" fill="#000" stroke="#000" stroke-width="3"/></mask><g mask="url(#m)">{g}</g>'
def drops(xs): return ''.join(f'<line x1="{x}" y1="18" x2="{x-1.2}" y2="21.4"/>' for x in xs)
def flake(x,y=19.7,r=1.7): return ''.join(f'<line x1="{x+r*math.cos(a):.2f}" y1="{y+r*math.sin(a):.2f}" x2="{x-r*math.cos(a):.2f}" y2="{y-r*math.sin(a):.2f}"/>' for a in (math.pi/2,math.pi/6,5*math.pi/6))
BOLT='<path d="M12.8 14.2l-2.6 4h3.4l-2.4 4" />'
def compose(name):
    base=name.replace('-night','')
    night=name.endswith('-night')
    kind='moon' if night else 'sun'
    has_small='sun' in base and base not in('sun',) or base in('lightcloud','partlycloud')
    if base=='sun': return moon_big() if night else sun_big()
    if base=='nodata': return '<path d="M8.6 9a3.5 3.5 0 1 1 5.6 2.8c-1.3 1-2.2 1.7-2.2 3.4"/><line x1="12" y1="18.6" x2="12" y2="18.7" stroke-width="2"/>'
    if base=='fog': return cloud(-3.5)+'<line x1="5" y1="18.5" x2="19" y2="18.5"/><line x1="7.5" y1="21.5" x2="16.5" y2="21.5"/>'
    precip='rain' in base or 'sleet' in base or 'snow' in base
    thunder='thunder' in base
    dy=-3.5 if (precip or thunder) else 0
    o=''
    if has_small: o+=small(kind,dy)
    o+=cloud(dy)
    if thunder: o+=BOLT
    if 'lightrain' in base: o+=drops((8.5,) if thunder else (9.5,14.5)) + (drops((16.5,)) if thunder else '')
    elif 'rain' in base: o+=drops((8,) if thunder else (7.5,12,16.5)) + (drops((16.5,)) if thunder else '')
    elif 'sleet' in base: o+=(drops((7.5,))+flake(17)) if thunder else (drops((8,))+flake(12.5)+drops((17.5,)))
    elif 'snow' in base: o+=(flake(7.5)+flake(17)) if thunder else (flake(7)+flake(12)+flake(17))
    return o
NAMES='cloud fog lightcloud lightcloud-night lightrain lightrainsun lightrainsun-night lightrainthunder lightrainthundersun lightrainthundersun-night nodata partlycloud partlycloud-night rain rainthunder sleet sleetsun sleetsun-night sleetsunthunder sleetsunthunder-night sleetthunder snow snowsun snowsun-night snowsunthunder snowsunthunder-night snowthunder sun sun-night'.split()
for s in (22,48,128): os.makedirs(f'{T}/{s}',exist_ok=True)
open(f'{T}/theme.info','w').write('Name=Jade Outline\nAuthor=Jade-dark\nDescription=Konturowe ikony pogody w kolorze motywu Jade-dark\nLicense=GPL-3\n')
fd,tmp=tempfile.mkstemp(suffix='.svg'); os.close(fd)
for n in NAMES:
    svg=f'<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="none" stroke="{C}" stroke-width="{SW}" stroke-linecap="round" stroke-linejoin="round">{compose(n)}</g></svg>'
    open(tmp,'w').write(svg)
    for s in (22,48,128): GdkPixbuf.Pixbuf.new_from_file_at_scale(tmp,s,s,True).savev(f'{T}/{s}/{n}.png','png',[],[])
os.remove(tmp); print('ikon',len(NAMES))
