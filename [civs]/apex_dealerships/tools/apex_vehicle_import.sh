#!/usr/bin/env bash
# =========================================================================
#  APEX VEHICLE IMPORTER  --  apex_dealerships   (Linux / macOS)
#
#  Drop this next to the vehicle resource's fxmanifest.lua (the folder with
#  stream/ and vehicles.meta) and run it:
#
#      chmod +x apex_vehicle_import.sh
#      ./apex_vehicle_import.sh                 # scans the folder it sits in
#      ./apex_vehicle_import.sh /path/to/res    # or an explicit folder
#
#  It reads vehicles.meta / handling.meta, works out which models are ADDON
#  and which REPLACE a base-game car, and writes:
#      vehicles.lua                    -> picked up by /dealerships > Import
#      apex_import/apex_vehicles.sql   -> direct DB import
#      apex_import/apex_vehicles.json  -> generic export
#      apex_import/report.txt          -> addon/replace/skipped breakdown
#
#  Optional: export GROQ_API_KEY=... (free at https://console.groq.com) and an
#  AI fills in real display names, brands, categories and prices.
#
#  Requires: python3 (present on every modern Linux distro / macOS).
# =========================================================================
set -euo pipefail

DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

if ! command -v python3 >/dev/null 2>&1; then
    echo "  [err] python3 is required (apt install python3 / brew install python3)" >&2
    exit 1
fi

exec python3 - "$DIR" <<'PY_EOF'
import json
import os
import re
import sys
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime

ROOT = os.path.abspath(sys.argv[1])

C_OK, C_INFO, C_WARN, C_ERR, C_HEAD, C_DIM, C_END = (
    "\033[92m", "\033[96m", "\033[93m", "\033[91m", "\033[94m", "\033[90m", "\033[0m")

def line():  print(C_DIM + "-" * 74 + C_END)
def ok(m):   print(f"  {C_OK}[ok]{C_END}   {m}")
def info(m): print(f"  {C_INFO}[info]{C_END} {m}")
def warn(m): print(f"  {C_WARN}[warn]{C_END} {m}")
def err(m):  print(f"  {C_ERR}[err]{C_END}  {m}")

print()
print(f"  {C_HEAD}APEX VEHICLE IMPORTER{C_END}")
print(f"  {C_DIM}apex_dealerships - stream resource scanner{C_END}")
line()
info(f"Resource: {ROOT}")

# -------------------------------------------------------------------------
# Base-game spawn codes (to tell REPLACE from ADDON)
# -------------------------------------------------------------------------
BASE = set("""adder airbus airtug akula akuma aleutian alpha alphaz1 ambulance annihilator apc ardent armytanker 
armytrailer armytrailer2 asbo asea asterope asterope2 astron autarch avarus avenger bagger 
baletrailer baller2 baller3 baller4 baller7 baller8 banshee banshee2 banshee3 barracks barracks2 
barracks3 bati bati2 benson besra bestiagts bf400 bfinjection biff bifta bison bison2 bison3 
bjxl blade blazer blazer3 blazer4 blimp blimp2 blimp3 blista blista2 blista3 bmx boattrailer 
bodhi2 bombushka boor boxville boxville2 boxville3 boxville4 boxville5 brawler brickade brickade2 
brigham brioso brioso2 brioso3 broadway bruiser bruiser2 bruiser3 brutus brutus2 brutus3 btype 
btype2 btype3 buccaneer buccaneer2 buffalo buffalo2 buffalo3 buffalo4 buffalo5 bullet burrito 
burrito2 burrito4 bus buzzard buzzard2 cablecar caddy caddy2 caddy3 calico camper caracara2 
carbonizzare carbonrs cargobob cargobob2 cargobob3 cargobob4 cargoplane casco cavalcade cavalcade3 
cerberus cerberus2 cerberus3 champion cheburek cheetah cheetah2 chimera chino chino2 cinquemila 
cliffhanger clique clique2 club coach cog55 cogcabrio cognoscenti comet2 comet3 comet4 comet5 
comet6 comet7 contender coquette coquette2 coquette3 coquette4 corsita cruiser crusader cuban800 
cutter cyclone cypher daemon daemon2 deathbike deathbike2 deathbike3 defiler deity deluxo deveste 
deviant diablous diablous2 dilettante dinghy dinghy2 dinghy3 dinghy4 docktrailer docktug dodo 
dominator dominator2 dominator3 dominator4 dominator5 dominator6 dominator7 dominator8 dominator9 
dorado double drafter draugur dubsta dubsta3 dukes dukes2 dukes3 dumper dune dune3 dune4 dune5 
duster dynasty elegy elegy2 emerus emperor enduro entity2 entity3 entityxf envisage esskey 
eudora euros everon exemplar f620 faction faction2 faction3 fagaloa faggio faggio2 faggio3 
fbi fbi2 fcr fcr2 felon felon2 feltzer2 feltzer3 firetruk fixter flashgt flatbed fmj forklift 
fq2 fr36 freecrawler freight freightcar frogger frogger2 fugitive furia furoregt fusilade futo 
futo2 gargoyle gauntlet gauntlet2 gauntlet3 gauntlet4 gauntlet5 gb200 gburrito glendale glendale2 
gp1 graintrailer granger granger2 greenwood gresley growler gt500 habanero hakuchou hakuchou2 
halftrack handler hauler hauler2 havok hellion hermes hexer hotknife hotring hotring2 hotring3 
howard hunter huntley hustler hydra ignus imorgon impaler impaler2 impaler3 impaler4 impaler5 
impaler6 inductor inductor2 infernus infernus2 ingot innovation insurgent insurgent2 insurgent3 
intruder issi2 issi3 issi4 issi5 issi6 issi7 issi8 italigtb italigtb2 italigto italigto2 italirsx 
iwagen jackal jb700 jester jester2 jester3 jester4 jet jetmax journey journey2 jubilee jugular 
kalahari kamacho kanjo kanjosj khamelion khanjali komoda krieger kuruma kuruma2 l35 landstalker 
landstalker2 lazer le7b lectro lguard lm87 locust lurcher luxor luxor2 lynx mamba mammatus 
manana manana2 manchez manchez2 manchez3 marquis massacro massacro2 maverick menacer mesa mesa3 
metrotrain michelli miljet minitank minivan minivan2 mixer mixer2 mogul molotok monroe monster 
monster3 monster4 monster5 monstrociti moonbeam moonbeam2 mower mule mule2 mule3 mule4 nebula 
nemesis neo neon nero nero2 nightblade nightshade nimbus ninef ninef2 niobe nokota novak omnis 
omnisegt oppressor oppressor2 oracle oracle2 osiris outlaw packer panthere panto paradise paragon 
pariah patriot patriot2 patriot3 pbus pcj penetrator penumbra penumbra2 peyote peyote2 peyote3 
pfister811 phantom phantom2 phantom3 phantom4 phoenix picador pigalle pipistrello police police2 
police3 police4 policeb policeold1 policeold2 policet polmav pony pony2 postlude pounder pounder2 
powersurge prairie pranger predator premier previon primo primo2 prototipo pyro r300 radi raiden 
raketrailer rancherxl rapidgt rapidgt2 rapidgt3 raptor ratbike ratel ratloader ratloader2 reaper 
rebel rebel2 rebla reever regina remus rentalbus retinue retinue2 revolter rhapsody rhinehart 
rhino riata riot riot2 ripley rocoto rogue romero rrocket rt3000 rubble ruffian ruiner ruiner2 
ruiner4 rumpo rumpo2 rumpo3 ruston s80 sabregt sabregt2 sadler sadler2 sanchez sanctus sandking 
sandking2 savage savestra sc1 scarab scarab2 scarab3 schafter2 schafter3 schafter4 schlagen 
schwarzer scorcher scramjet scrap seabreeze seashark seashark2 seashark3 seasparrow seminole 
seminole2 sentinel sentinel2 sentinel3 sentinel4 serrano seven70 shamal sheava sheriff sheriff2 
shinobi shotaro skylift slamvan slamvan2 slamvan3 slamvan4 slamvan5 slamvan6 sm722 sovereign 
 specter specter2 speeder speeder2 speedo speedo2 speedo4 squaddie squalo stafford 
stalion stalion2 stanier starling stinger stingergt stockade stockade3 stratum streiter stretch 
strikeforce stromberg stryder stunt submersible submersible2 sugoi sultan sultan2 sultan3 sultanrs 
suntrap superd supervolito supervolito2 surano surfer surfer3 surge swift swift2 swinger t20 
taco tahoma tailgater tailgater2 taipan tampa tampa2 tanker tanker2 taxi technical technical2 
technical3 tempesta tenf tenf2 terminus tezeract thrax thrust tigon tiptruck tiptruck2 titan 
toreador torero torero2 tornado tornado5 tornado6 toro toro2 toros towtruck towtruck2 tractor 
tractor2 tractor3 trailers trailers2 trailers3 trailersmall tram trash trash2 trflat tribike 
tribike2 tribike3 trophytruck trophytruck2 tropic tropic2 tropos tug tula tulip tulip2 turismo2 
turismo3 turismor tvtrailer tyrant tyrus utillitruck utillitruck2 utillitruck3 vacca vader 
vagner vagrant valkyrie valkyrie2 vamos vectre velum velum2 verlierer2 verus vestra veto veto2 
vigero vigero2 vigero3 vigilante vindicator virgo virgo2 virgo3 virtue viseris visione vivanite 
volatol volatus voltic voodoo voodoo2 vorschlaghammer vortex vstr warrener warrener2 washington 
weevil weevil2 windsor windsor2 winky wolfsbane xa21 xls yosemite yosemite2 yosemite3 youga 
youga2 youga3 youga4 z190 zentorno zhaba zion zion2 zion3 zombiea zombieb zorrusso zr350 ztype""".split())

CLASSMAP = {
    'VC_COMPACT': 'compacts', 'VC_SEDAN': 'sedans', 'VC_SUV': 'suvs',
    'VC_COUPE': 'coupes', 'VC_MUSCLE': 'muscle', 'VC_SPORT_CLASSIC': 'sportsclassics',
    'VC_SPORT': 'sports', 'VC_SUPER': 'super', 'VC_MOTORCYCLE': 'motorcycles',
    'VC_OFF_ROAD': 'offroad', 'VC_INDUSTRIAL': 'commercial', 'VC_UTILITY': 'commercial',
    'VC_VAN': 'vans', 'VC_SERVICE': 'commercial', 'VC_EMERGENCY': 'commercial',
    'VC_MILITARY': 'offroad', 'VC_COMMERCIAL': 'commercial',
    # air / sea domains (apex_dealerships v3)
    'VC_HELICOPTER': 'helicopters', 'VC_PLANE': 'planes', 'VC_BOAT': 'boats',
}
BADTYPE = {'VEHICLE_TYPE_TRAIN', 'VEHICLE_TYPE_SUBMARINE', 'VEHICLE_TYPE_BICYCLE',
           'VEHICLE_TYPE_TRAILER', 'VEHICLE_TYPE_BLIMP'}
BADCLASS = {'VC_CYCLE', 'VC_TRAIN', 'VC_RAIL'}
TYPE_CAT = {
    'VEHICLE_TYPE_BIKE': 'motorcycles', 'VEHICLE_TYPE_QUADBIKE': 'motorcycles',
    'VEHICLE_TYPE_HELI': 'helicopters', 'VEHICLE_TYPE_PLANE': 'planes',
    'VEHICLE_TYPE_BOAT': 'boats',
}
BASEPRICE = {
    'compacts': 15000, 'sedans': 22000, 'suvs': 45000, 'coupes': 55000, 'muscle': 45000,
    'sportsclassics': 95000, 'sports': 110000, 'super': 550000, 'motorcycles': 30000,
    'offroad': 40000, 'vans': 22000, 'commercial': 50000,
    'helicopters': 1500000, 'planes': 1200000, 'boats': 200000, 'jetskis': 35000,
}
CATEGORIES = ', '.join(BASEPRICE.keys())

def walk(pattern):
    hits = []
    for dirpath, _dirnames, filenames in os.walk(ROOT):
        for fn in filenames:
            if fn.lower() == pattern:
                hits.append(os.path.join(dirpath, fn))
    return hits

def text_of(node, tag):
    el = node.find(tag)
    if el is None:
        return ''
    return (el.text or '').strip()

def value_of(node, tag):
    el = node.find(tag)
    if el is None:
        return ''
    return (el.get('value') or el.text or '').strip()

# -------------------------------------------------------------------------
# handling.meta -> per-handlingId stats
# -------------------------------------------------------------------------
handling = {}
hand_files = walk('handling.meta')
meta_files = walk('vehicles.meta')
info(f"vehicles.meta found: {len(meta_files)}   handling.meta found: {len(hand_files)}")

for hf in hand_files:
    try:
        root = ET.parse(hf).getroot()
        for item in root.iter('Item'):
            hid = text_of(item, 'handlingName').lower()
            if not hid:
                continue
            def num(tag):
                try:
                    return float(value_of(item, tag) or 0)
                except ValueError:
                    return 0.0
            handling[hid] = {
                'mass': num('fMass'),
                'speed': num('nInitialDriveMaxFlatVel'),
                'gears': int(num('nInitialDriveGears')),
            }
    except Exception as e:  # noqa: BLE001
        warn(f"could not parse {os.path.basename(hf)}: {e}")

# -------------------------------------------------------------------------
# vehicles.meta -> vehicles
# -------------------------------------------------------------------------
found, skipped, seen = [], [], set()

for mf in meta_files:
    try:
        root = ET.parse(mf).getroot()
        for item in root.iter('Item'):
            model = text_of(item, 'modelName').lower()
            if not model or model in seen:
                continue
            vtype = text_of(item, 'type').upper()
            vclass = value_of(item, 'vehicleClass').upper()

            if vtype in BADTYPE:
                skipped.append((model, vtype)); continue
            if vclass in BADCLASS:
                skipped.append((model, vclass)); continue

            cat = CLASSMAP.get(vclass, 'sedans')
            if vtype in TYPE_CAT:
                cat = TYPE_CAT[vtype]

            seen.add(model)
            found.append({
                'model': model,
                'name': text_of(item, 'gameName') or model.upper(),
                'brand': text_of(item, 'vehicleMakeName').title(),
                'category': cat,
                'handling': (text_of(item, 'handlingId') or model).lower(),
                'kind': 'replace' if model in BASE else 'addon',
            })
    except Exception as e:  # noqa: BLE001
        warn(f"could not parse {mf}: {e}")

# fallback: no metas -> read the stream folder
if not found:
    warn('No vehicles.meta entries - falling back to the stream folder (.yft names).')
    for dirpath, _d, filenames in os.walk(ROOT):
        for fn in filenames:
            if not fn.lower().endswith('.yft'):
                continue
            m = re.sub(r'(_hi|\+hi)$', '', os.path.splitext(fn)[0].lower())
            if m in seen:
                continue
            seen.add(m)
            found.append({
                'model': m, 'name': m.upper(), 'brand': '', 'category': 'sedans',
                'handling': m, 'kind': 'replace' if m in BASE else 'addon',
            })

if not found:
    err('No vehicles found here. Run this from the resource root (the folder with stream/ and vehicles.meta).')
    sys.exit(1)

addon = [v for v in found if v['kind'] == 'addon']
replace = [v for v in found if v['kind'] == 'replace']
line()
ok(f"{len(found)} vehicle(s): {len(addon)} addon, {len(replace)} replace   (skipped: {len(skipped)})")

# -------------------------------------------------------------------------
# Prices from handling
# -------------------------------------------------------------------------
def guess_price(v):
    base = BASEPRICE.get(v['category'], 25000)
    h = handling.get(v['handling'])
    if not h:
        return int(base)
    mult = 1.0
    if h['speed'] > 0:
        mult = max(0.55, min(2.2, h['speed'] / 45.0))
    if h['gears'] >= 7:
        mult *= 1.25
    elif h['gears'] == 6:
        mult *= 1.10
    return max(5000, int(round(base * mult / 500.0) * 500))

for v in found:
    v['price'] = guess_price(v)

# -------------------------------------------------------------------------
# Optional AI pass (Groq)
# -------------------------------------------------------------------------
key = os.environ.get('GROQ_API_KEY', '').strip()
keyfile = os.path.join(ROOT, 'groq.key')
if not key and os.path.isfile(keyfile):
    key = open(keyfile, encoding='utf-8').read().strip()
if not key and sys.stdin.isatty():
    line()
    print('  An AI pass can fill in proper display names, brands, categories and')
    print('  realistic prices for every vehicle. It is optional and free.')
    print('  Get a key at https://console.groq.com  (or press Enter to skip)')
    try:
        key = input('  Groq API key: ').strip()
    except EOFError:
        key = ''
    if key and input('  Save it to groq.key for next time? (y/N) ').strip().lower() == 'y':
        open(keyfile, 'w', encoding='utf-8').write(key)
        ok('saved groq.key')

if key:
    line()
    info('Asking the AI to clean up names / brands / categories / prices...')
    SYS = (
        "You name and price vehicles for a FiveM roleplay dealership. For each vehicle you get "
        "its spawn code and whatever metadata the resource had. Infer the REAL vehicle it is (most "
        "FiveM addons are real-life vehicles) and return a clean display name (e.g. 'M4 Competition'), "
        f"the manufacturer as brand (e.g. 'BMW'), one category from: {CATEGORIES}, and a realistic "
        "in-game price in dollars. Keep the spawn code EXACTLY as given. Answer ONLY with JSON: "
        '{"vehicles":[{"model":"","name":"","brand":"","category":"","price":0}]}'
    )
    BATCH = 35
    by_model = {v['model']: v for v in found}
    for i in range(0, len(found), BATCH):
        chunk = found[i:i + BATCH]
        payload = [{k: v[k] for k in ('model', 'name', 'brand', 'category', 'price')} for v in chunk]
        body = json.dumps({
            'model': 'llama-3.3-70b-versatile',
            'temperature': 0.2,
            'response_format': {'type': 'json_object'},
            'messages': [
                {'role': 'system', 'content': SYS},
                {'role': 'user', 'content': json.dumps(payload)},
            ],
        }).encode('utf-8')
        req = urllib.request.Request(
            'https://api.groq.com/openai/v1/chat/completions', data=body,
            headers={'Authorization': f'Bearer {key}', 'Content-Type': 'application/json'})
        try:
            with urllib.request.urlopen(req, timeout=90) as res:
                data = json.loads(res.read().decode('utf-8'))
            out = json.loads(data['choices'][0]['message']['content'])
            for r in out.get('vehicles', []):
                tgt = by_model.get(str(r.get('model', '')).lower())
                if not tgt:
                    continue
                if r.get('name'):
                    tgt['name'] = str(r['name']).strip()
                if r.get('brand'):
                    tgt['brand'] = str(r['brand']).strip()
                cat = str(r.get('category', '')).lower()
                if cat in BASEPRICE:
                    tgt['category'] = cat
                try:
                    p = int(r.get('price') or 0)
                    if p > 0:
                        tgt['price'] = p
                except (TypeError, ValueError):
                    pass
            ok(f"AI: {min(i + BATCH, len(found))}/{len(found)}")
        except (urllib.error.URLError, KeyError, ValueError) as e:  # noqa: PERF203
            warn(f"AI batch failed ({e}) - keeping the heuristic values.")
else:
    info('No AI key - using the heuristic names/prices from the meta files.')

# -------------------------------------------------------------------------
# Output
# -------------------------------------------------------------------------
out_dir = os.path.join(ROOT, 'apex_import')
os.makedirs(out_dir, exist_ok=True)
stamp = datetime.now().strftime('%Y-%m-%d %H:%M')
res_name = os.path.basename(ROOT)
vehicles = sorted(found, key=lambda v: (v['category'], v['name'].lower()))

def lua_str(s):
    return "'" + str(s).replace('\\', '\\\\').replace("'", "\\'") + "'"

def sql_str(s):
    return "'" + str(s).replace("'", "''") + "'"

lua_path = os.path.join(ROOT, 'vehicles.lua')
if os.path.isfile(lua_path):
    with open(lua_path, encoding='utf-8', errors='replace') as f:
        open(os.path.join(out_dir, 'vehicles.lua.bak'), 'w', encoding='utf-8').write(f.read())
    warn('existing vehicles.lua backed up to apex_import/vehicles.lua.bak')

with open(lua_path, 'w', encoding='utf-8') as f:
    f.write(f"--[[ Generated by the Apex Vehicle Importer - {stamp}\n")
    f.write(f"     Resource: {res_name}\n")
    f.write(f"     {len(found)} vehicles ({len(addon)} addon / {len(replace)} replace)\n")
    f.write("     Import them in-game: /dealerships -> Import -> this resource ]]\n\n")
    f.write("ApexVehicles = {\n")
    for v in vehicles:
        f.write("    {{ model = {}, name = {}, brand = {}, category = {}, price = {} }},  -- {}\n".format(
            lua_str(v['model']), lua_str(v['name']), lua_str(v['brand']),
            lua_str(v['category']), v['price'], v['kind']))
    f.write("}\n\nreturn ApexVehicles\n")

with open(os.path.join(out_dir, 'apex_vehicles.sql'), 'w', encoding='utf-8') as f:
    f.write(f"-- Apex Vehicle Importer - {stamp} - resource: {res_name}\n")
    f.write("-- Run against your server DB to add these vehicles to the dealership catalog.\n")
    f.write("INSERT INTO `apex_dealerships_catalog` (`model`, `brand`, `name`, `category`, `price`) VALUES\n")
    rows = ["({}, {}, {}, {}, {})".format(
        sql_str(v['model']), sql_str(v['brand']), sql_str(v['name']), sql_str(v['category']), v['price'])
        for v in vehicles]
    f.write(",\n".join(rows))
    f.write("\nON DUPLICATE KEY UPDATE `brand` = VALUES(`brand`), `name` = VALUES(`name`), "
            "`category` = VALUES(`category`), `price` = VALUES(`price`);\n")

with open(os.path.join(out_dir, 'apex_vehicles.json'), 'w', encoding='utf-8') as f:
    json.dump([{k: v[k] for k in ('model', 'name', 'brand', 'category', 'price', 'kind')}
               for v in vehicles], f, indent=2)

with open(os.path.join(out_dir, 'report.txt'), 'w', encoding='utf-8') as f:
    f.write(f"APEX VEHICLE IMPORTER - {stamp}\nResource: {res_name}\n")
    f.write(f"Total: {len(found)}   Addon: {len(addon)}   Replace: {len(replace)}   Skipped: {len(skipped)}\n\n")
    f.write("== ADDON (new spawn codes - safe to sell) ==\n")
    for v in sorted(addon, key=lambda x: x['model']):
        f.write(f"  {v['model']:<24} {v['brand']} {v['name']} [{v['category']}] ${v['price']}\n")
    f.write("\n== REPLACE (overwrite a base-game vehicle - probably ALREADY in your catalog) ==\n")
    for v in sorted(replace, key=lambda x: x['model']):
        f.write(f"  {v['model']:<24} {v['brand']} {v['name']} [{v['category']}] ${v['price']}\n")
    f.write("\n== SKIPPED (trains / trailers / bicycles) ==\n")
    for m, why in sorted(skipped):
        f.write(f"  {m:<24} {why}\n")

line()
ok(f"vehicles.lua       -> {lua_path}")
ok(f"apex_vehicles.sql  -> {out_dir}/apex_vehicles.sql")
ok(f"apex_vehicles.json -> {out_dir}/apex_vehicles.json")
ok(f"report.txt         -> {out_dir}/report.txt")
line()
print(f"  {C_HEAD}NEXT STEPS{C_END}")
print("   1. In game (as admin): /dealerships  ->  Import tab")
print(f"   2. Pick the source '{res_name} / vehicles.lua' and hit Import.")
print('      (tick "Update existing vehicles" to overwrite prices/names of REPLACE cars)')
print("   3. The vehicles are now in the catalog - add their categories to a stand,")
print("      or build a curated Listing with exactly these vehicles.")
if replace:
    print()
    warn(f"{len(replace)} vehicle(s) REPLACE base-game vehicles - they already exist in the catalog.")
    print('         Import with "Update existing" if you want their new names/prices to win.')
print()
PY_EOF
