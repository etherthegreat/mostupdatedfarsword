import os,re,glob,collections,json
SKIP=('./_','./zz_test','./.git','./.godot','./sim_runs')
refs=collections.defaultdict(set)
pat=re.compile(r'res://([^"\n]*?\.(?:png|PNG|jpg|svg|webp))')
for root,ds,fs in os.walk('.'):
    if root.startswith(SKIP): ds[:]=[];continue
    for f in fs:
        if f.endswith(('.tscn','.gd','.csv','.tres')) and '.tmp' not in f:
            p=os.path.join(root,f)
            try: s=open(p,encoding='utf-8',errors='ignore').read()
            except: continue
            for m in pat.finditer(s): refs[m.group(1)].add(p[2:])
# dynamic dir refs in gd
out=[]
for r,users in sorted(refs.items()):
    out.append((r, os.path.exists(r), sorted(users)))
json.dump(out,open('zz_test/art_refs.json','w'),indent=0)
print(len(out),'refs;', sum(1 for o in out if not o[1]),'missing')
cats=collections.Counter(o[0].split('/')[1] if o[0].startswith('art assets/') else 'other' for o in out); print(cats)
