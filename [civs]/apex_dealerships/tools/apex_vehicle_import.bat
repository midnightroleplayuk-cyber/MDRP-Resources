@echo off
rem ===========================================================================
rem  APEX VEHICLE IMPORTER  --"  apex_dealerships
rem  Drop this .bat inside a FiveM vehicle resource (the folder with the
rem  stream/ + vehicles.meta) and double-click it.
rem
rem  It scans the resource, works out which vehicles are ADDON and which are
rem  REPLACE, and writes:
rem     vehicles.lua                 -> picked up by /dealerships > Import
rem     apex_import\apex_vehicles.sql   -> direct DB import (catalog table)
rem     apex_import\apex_vehicles.json  -> generic export
rem     apex_import\report.txt          -> addon/replace/skipped breakdown
rem
rem  Optional: a free Groq API key (https://console.groq.com) makes an AI fill
rem  in proper display names, brands, categories and realistic prices.
rem ===========================================================================
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -Command "$t=[IO.File]::ReadAllText('%~f0'); $k='#PS'+'CODE#'; $i=$t.IndexOf($k); if($i -lt 0){Write-Host 'payload marker not found'; exit 1}; $f=Join-Path $env:TEMP ('apexvi_'+[guid]::NewGuid().ToString('N')+'.ps1'); [IO.File]::WriteAllText($f, $t.Substring($i+$k.Length)); try { & $f '%~dp0' } finally { Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue }"
echo.
pause
exit /b
#PSCODE#

# =========================================================================
#  APEX VEHICLE IMPORTER --" PowerShell payload
# =========================================================================
param([string]$ResourceDir)
$ErrorActionPreference = 'Stop'
$root = $ResourceDir
if ($root) { $root = $root.TrimEnd('\') }
if (-not $root -or -not (Test-Path -LiteralPath $root)) { $root = (Get-Location).Path }
$root = (Resolve-Path -LiteralPath $root).Path

function Line($c) { Write-Host ('-' * 74) -ForegroundColor DarkGray }
function Ok($m)   { Write-Host "  [ok]   $m" -ForegroundColor Green }
function Info($m) { Write-Host "  [info] $m" -ForegroundColor Cyan }
function Warn($m) { Write-Host "  [warn] $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "  [err]  $m" -ForegroundColor Red }

Write-Host ''
Write-Host '  APEX VEHICLE IMPORTER' -ForegroundColor Blue
Write-Host '  apex_dealerships - stream resource scanner' -ForegroundColor DarkGray
Line
Info "Resource: $root"

# -------------------------------------------------------------------------
# Base-game spawn codes (used to tell REPLACE from ADDON)
# -------------------------------------------------------------------------
$BASE = @('adder','airbus','airtug','akula','akuma','aleutian','alpha','alphaz1','ambulance','annihilator','apc',
'ardent','armytanker','armytrailer','armytrailer2','asbo','asea','asterope','asterope2','astron','autarch',
'avarus','avenger','bagger','baletrailer','baller2','baller3','baller4','baller7','baller8','banshee',
'banshee2','banshee3','barracks','barracks2','barracks3','bati','bati2','benson','besra','bestiagts',
'bf400','bfinjection','biff','bifta','bison','bison2','bison3','bjxl','blade','blazer','blazer3','blazer4',
'blimp','blimp2','blimp3','blista','blista2','blista3','bmx','boattrailer','bodhi2','bombushka','boor',
'boxville','boxville2','boxville3','boxville4','boxville5','brawler','brickade','brickade2','brigham',
'brioso','brioso2','brioso3','broadway','bruiser','bruiser2','bruiser3','brutus','brutus2','brutus3',
'btype','btype2','btype3','buccaneer','buccaneer2','buffalo','buffalo2','buffalo3','buffalo4','buffalo5',
'bullet','burrito','burrito2','burrito4','bus','buzzard','buzzard2','cablecar','caddy','caddy2','caddy3',
'calico','camper','caracara2','carbonizzare','carbonrs','cargobob','cargobob2','cargobob3','cargobob4',
'cargoplane','casco','cavalcade','cavalcade3','cerberus','cerberus2','cerberus3','champion','cheburek',
'cheetah','cheetah2','chimera','chino','chino2','cinquemila','cliffhanger','clique','clique2','club',
'coach','cog55','cogcabrio','cognoscenti','comet2','comet3','comet4','comet5','comet6','comet7','contender',
'coquette','coquette2','coquette3','coquette4','corsita','cruiser','crusader','cuban800','cutter','cyclone',
'cypher','daemon','daemon2','deathbike','deathbike2','deathbike3','defiler','deity','deluxo','deveste',
'deviant','diablous','diablous2','dilettante','dinghy','dinghy2','dinghy3','dinghy4','docktrailer','docktug',
'dodo','dominator','dominator2','dominator3','dominator4','dominator5','dominator6','dominator7','dominator8',
'dominator9','dorado','double','drafter','draugur','dubsta','dubsta3','dukes','dukes2','dukes3','dumper',
'dune','dune3','dune4','dune5','duster','dynasty','elegy','elegy2','emerus','emperor','enduro','entity2',
'entity3','entityxf','envisage','esskey','eudora','euros','everon','exemplar','f620','faction','faction2',
'faction3','fagaloa','faggio','faggio2','faggio3','fbi','fbi2','fcr','fcr2','felon','felon2','feltzer2',
'feltzer3','firetruk','fixter','flashgt','flatbed','fmj','forklift','fq2','fr36','freecrawler','freight',
'freightcar','frogger','frogger2','fugitive','furia','furoregt','fusilade','futo','futo2','gargoyle',
'gauntlet','gauntlet2','gauntlet3','gauntlet4','gauntlet5','gb200','gburrito','glendale','glendale2',
'gp1','graintrailer','granger','granger2','greenwood','gresley','growler','gt500','habanero','hakuchou',
'hakuchou2','halftrack','handler','hauler','hauler2','havok','hellion','hermes','hexer','hotknife','hotring',
'hotring2','hotring3','howard','hunter','huntley','hustler','hydra','ignus','imorgon','impaler','impaler2',
'impaler3','impaler4','impaler5','impaler6','inductor','inductor2','infernus','infernus2','ingot','innovation',
'insurgent','insurgent2','insurgent3','intruder','issi2','issi3','issi4','issi5','issi6','issi7','issi8',
'italigtb','italigtb2','italigto','italigto2','italirsx','iwagen','jackal','jb700','jester','jester2',
'jester3','jester4','jet','jetmax','journey','journey2','jubilee','jugular','kalahari','kamacho','kanjo',
'kanjosj','khamelion','khanjali','komoda','krieger','kuruma','kuruma2','l35','landstalker','landstalker2',
'lazer','le7b','lectro','lguard','lm87','locust','lurcher','luxor','luxor2','lynx','mamba','mammatus',
'manana','manana2','manchez','manchez2','manchez3','marquis','massacro','massacro2','maverick','menacer',
'mesa','mesa3','metrotrain','michelli','miljet','minitank','minivan','minivan2','mixer','mixer2','mogul',
'molotok','monroe','monster','monster3','monster4','monster5','monstrociti','moonbeam','moonbeam2','mower',
'mule','mule2','mule3','mule4','nebula','nemesis','neo','neon','nero','nero2','nightblade','nightshade',
'nimbus','ninef','ninef2','niobe','nokota','novak','omnis','omnisegt','oppressor','oppressor2','oracle',
'oracle2','osiris','outlaw','packer','panthere','panto','paradise','paragon','pariah','patriot','patriot2',
'patriot3','pbus','pcj','penetrator','penumbra','penumbra2','peyote','peyote2','peyote3','pfister811',
'phantom','phantom2','phantom3','phantom4','phoenix','picador','pigalle','pipistrello','police','police2',
'police3','police4','policeb','policeold1','policeold2','policet','polmav','pony','pony2','postlude',
'pounder','pounder2','powersurge','prairie','pranger','predator','premier','previon','primo','primo2',
'prototipo','pyro','r300','radi','raiden','raketrailer','rancherxl','rapidgt','rapidgt2','rapidgt3','raptor',
'ratbike','ratel','ratloader','ratloader2','reaper','rebel','rebel2','rebla','reever','regina','remus',
'rentalbus','retinue','retinue2','revolter','rhapsody','rhinehart','rhino','riata','riot','riot2','ripley',
'rocoto','rogue','romero','rrocket','rt3000','rubble','ruffian','ruiner','ruiner2','ruiner4','rumpo',
'rumpo2','rumpo3','ruston','s80','sabregt','sabregt2','sadler','sadler2','sanchez','sanctus','sandking',
'sandking2','savage','savestra','sc1','scarab','scarab2','scarab3','schafter2','schafter3','schafter4',
'schlagen','schwarzer','scorcher','scramjet','scrap','seabreeze','seashark','seashark2','seashark3','seasparrow',
'seminole','seminole2','sentinel','sentinel2','sentinel3','sentinel4','serrano','seven70','shamal','sheava',
'sheriff','sheriff2','shinobi','shotaro','skylift','slamvan','slamvan2','slamvan3','slamvan4','slamvan5',
'slamvan6','sm722','sovereign','spawn_code','specter','specter2','speeder','speeder2','speedo','speedo2',
'speedo4','squaddie','squalo','stafford','stalion','stalion2','stanier','starling','stinger','stingergt',
'stockade','stockade3','stratum','streiter','stretch','strikeforce','stromberg','stryder','stunt','submersible',
'submersible2','sugoi','sultan','sultan2','sultan3','sultanrs','suntrap','superd','supervolito','supervolito2',
'surano','surfer','surfer3','surge','swift','swift2','swinger','t20','taco','tahoma','tailgater','tailgater2',
'taipan','tampa','tampa2','tanker','tanker2','taxi','technical','technical2','technical3','tempesta',
'tenf','tenf2','terminus','tezeract','thrax','thrust','tigon','tiptruck','tiptruck2','titan','toreador',
'torero','torero2','tornado','tornado5','tornado6','toro','toro2','toros','towtruck','towtruck2','tractor',
'tractor2','tractor3','trailers','trailers2','trailers3','trailersmall','tram','trash','trash2','trflat',
'tribike','tribike2','tribike3','trophytruck','trophytruck2','tropic','tropic2','tropos','tug','tula',
'tulip','tulip2','turismo2','turismo3','turismor','tvtrailer','tyrant','tyrus','utillitruck','utillitruck2',
'utillitruck3','vacca','vader','vagner','vagrant','valkyrie','valkyrie2','vamos','vectre','velum','velum2',
'verlierer2','verus','vestra','veto','veto2','vigero','vigero2','vigero3','vigilante','vindicator','virgo',
'virgo2','virgo3','virtue','viseris','visione','vivanite','volatol','volatus','voltic','voodoo','voodoo2',
'vorschlaghammer','vortex','vstr','warrener','warrener2','washington','weevil','weevil2','windsor','windsor2',
'winky','wolfsbane','xa21','xls','yosemite','yosemite2','yosemite3','youga','youga2','youga3','youga4',
'z190','zentorno','zhaba','zion','zion2','zion3','zombiea','zombieb','zorrusso','zr350','ztype')
$BASESET = @{}
foreach ($b in $BASE) { $BASESET[$b] = $true }

# -------------------------------------------------------------------------
# Category mapping
# -------------------------------------------------------------------------
$CLASSMAP = @{
    'VC_COMPACT' = 'compacts'; 'VC_SEDAN' = 'sedans'; 'VC_SUV' = 'suvs';
    'VC_COUPE' = 'coupes'; 'VC_MUSCLE' = 'muscle'; 'VC_SPORT_CLASSIC' = 'sportsclassics';
    'VC_SPORT' = 'sports'; 'VC_SUPER' = 'super'; 'VC_MOTORCYCLE' = 'motorcycles';
    'VC_OFF_ROAD' = 'offroad'; 'VC_INDUSTRIAL' = 'commercial'; 'VC_UTILITY' = 'commercial';
    'VC_VAN' = 'vans'; 'VC_SERVICE' = 'commercial'; 'VC_EMERGENCY' = 'commercial';
    'VC_MILITARY' = 'offroad'; 'VC_COMMERCIAL' = 'commercial';
    # air / sea domains (apex_dealerships v3)
    'VC_HELICOPTER' = 'helicopters'; 'VC_PLANE' = 'planes'; 'VC_BOAT' = 'boats';
}
# the vehicle TYPE wins over the class for these (metas are often sloppy)
$TYPECAT = @{
    'VEHICLE_TYPE_BIKE' = 'motorcycles'; 'VEHICLE_TYPE_QUADBIKE' = 'motorcycles';
    'VEHICLE_TYPE_HELI' = 'helicopters'; 'VEHICLE_TYPE_PLANE' = 'planes';
    'VEHICLE_TYPE_BOAT' = 'boats';
}
# never sellable: rails, trailers, bicycles, submarines, blimps
$BADTYPE = 'VEHICLE_TYPE_TRAIN|VEHICLE_TYPE_SUBMARINE|VEHICLE_TYPE_BICYCLE|VEHICLE_TYPE_TRAILER|VEHICLE_TYPE_BLIMP'
$BADCLASS = @('VC_CYCLE', 'VC_TRAIN', 'VC_RAIL')

# rough price floor per category (used when there is no AI key)
$BASEPRICE = @{
    compacts = 15000; sedans = 22000; suvs = 45000; coupes = 55000; muscle = 45000;
    sportsclassics = 95000; sports = 110000; super = 550000; motorcycles = 30000;
    offroad = 40000; vans = 22000; commercial = 50000;
    helicopters = 1500000; planes = 1200000; boats = 200000; jetskis = 35000;
}

# -------------------------------------------------------------------------
# 1) vehicles.meta
# -------------------------------------------------------------------------
$metaFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter 'vehicles.meta' -ErrorAction SilentlyContinue)
$handFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter 'handling.meta' -ErrorAction SilentlyContinue)
Info ("vehicles.meta found: {0}   handling.meta found: {1}" -f $metaFiles.Count, $handFiles.Count)

# handling stats -> { handlingId = @{ mass; speed; gears } }
$handling = @{}
foreach ($hf in $handFiles) {
    try {
        [xml]$hx = Get-Content -LiteralPath $hf.FullName -Raw
        foreach ($item in $hx.SelectNodes('//Item[handlingName]')) {
            $id = ('' + $item.handlingName).Trim().ToLower()
            if (-not $id) { continue }
            $mass  = 0.0; $speed = 0.0; $gears = 0
            if ($item.fMass)                      { [double]::TryParse(('' + $item.fMass.value),                      [ref]$mass)  | Out-Null }
            if ($item.nInitialDriveMaxFlatVel)    { [double]::TryParse(('' + $item.nInitialDriveMaxFlatVel.value),    [ref]$speed) | Out-Null }
            if ($item.nInitialDriveGears)         { [int]::TryParse(('' + $item.nInitialDriveGears.value),            [ref]$gears) | Out-Null }
            $handling[$id] = @{ mass = $mass; speed = $speed; gears = $gears }
        }
    } catch { Warn "could not parse $($hf.Name): $($_.Exception.Message)" }
}

$found = @()      # every vehicle we could identify
$skipped = @()

foreach ($mf in $metaFiles) {
    try {
        [xml]$mx = Get-Content -LiteralPath $mf.FullName -Raw
        foreach ($item in $mx.SelectNodes('//Item[modelName]')) {
            $model = ('' + $item.modelName).Trim().ToLower()
            if (-not $model) { continue }

            $type = ('' + $item.type).Trim().ToUpper()
            $cls  = ''
            if ($item.vehicleClass) { $cls = ('' + $item.vehicleClass.value).Trim().ToUpper() }

            if ($type -and ($type -match $BADTYPE)) { $skipped += [pscustomobject]@{ model = $model; why = $type }; continue }
            if ($cls -and ($BADCLASS -contains $cls)) { $skipped += [pscustomobject]@{ model = $model; why = $cls }; continue }

            $cat = 'sedans'
            if ($cls -and $CLASSMAP.ContainsKey($cls)) { $cat = $CLASSMAP[$cls] }
            if ($type -and $TYPECAT.ContainsKey($type)) { $cat = $TYPECAT[$type] }

            $make = ''
            if ($item.vehicleMakeName) { $make = ('' + $item.vehicleMakeName).Trim() }
            $game = ''
            if ($item.gameName) { $game = ('' + $item.gameName).Trim() }
            $hid = $model
            if ($item.handlingId) { $hid = ('' + $item.handlingId).Trim().ToLower() }

            $found += [pscustomobject]@{
                model    = $model
                name     = if ($game) { $game } else { $model.ToUpper() }
                brand    = (Get-Culture).TextInfo.ToTitleCase($make.ToLower())
                category = $cat
                class    = $cls
                type     = $type
                handling = $hid
                kind     = if ($BASESET.ContainsKey($model)) { 'replace' } else { 'addon' }
            }
        }
    } catch { Warn "could not parse $($mf.FullName): $($_.Exception.Message)" }
}

# -------------------------------------------------------------------------
# 2) Fallback: no vehicles.meta -> read the stream folder
# -------------------------------------------------------------------------
if ($found.Count -eq 0) {
    Warn 'No vehicles.meta entries --" falling back to the stream folder (.yft names).'
    $yfts = @(Get-ChildItem -LiteralPath $root -Recurse -File -Include '*.yft' -ErrorAction SilentlyContinue |
              Where-Object { $_.BaseName -notmatch '(_hi|\+hi|_hi\d)$' })
    $seen = @{}
    foreach ($y in $yfts) {
        $m = $y.BaseName.ToLower()
        if ($m -match '^(.+)_hi$') { $m = $Matches[1] }
        if ($seen.ContainsKey($m)) { continue }
        $seen[$m] = $true
        $found += [pscustomobject]@{
            model = $m; name = $m.ToUpper(); brand = ''; category = 'sedans'
            class = ''; type = ''; handling = $m
            kind  = if ($BASESET.ContainsKey($m)) { 'replace' } else { 'addon' }
        }
    }
}

# de-dupe by model
$uniq = @{}
$vehicles = @()
foreach ($v in $found) {
    if ($uniq.ContainsKey($v.model)) { continue }
    $uniq[$v.model] = $true
    $vehicles += $v
}

if ($vehicles.Count -eq 0) {
    Err 'No vehicles found here. Put this .bat in the resource root (the folder with stream/ and vehicles.meta).'
    return
}

$addon   = @($vehicles | Where-Object { $_.kind -eq 'addon' })
$replace = @($vehicles | Where-Object { $_.kind -eq 'replace' })
Line
Ok  ("{0} vehicle(s): {1} addon, {2} replace   (skipped: {3})" -f $vehicles.Count, $addon.Count, $replace.Count, $skipped.Count)

# -------------------------------------------------------------------------
# 3) Prices --" heuristic from handling (mass / top speed / gears)
# -------------------------------------------------------------------------
function Guess-Price($v) {
    $base = 25000
    if ($BASEPRICE.ContainsKey($v.category)) { $base = $BASEPRICE[$v.category] }
    $h = $handling[$v.handling]
    if (-not $h) { return [int]$base }
    $speed = [double]$h.speed
    $gears = [int]$h.gears
    $mult = 1.0
    if ($speed -gt 0)  { $mult = [math]::Max(0.55, [math]::Min(2.2, $speed / 45.0)) }
    if ($gears -ge 7)  { $mult *= 1.25 }
    elseif ($gears -eq 6) { $mult *= 1.10 }
    $p = [int]([math]::Round(($base * $mult) / 500.0) * 500)
    return [math]::Max(5000, $p)
}
foreach ($v in $vehicles) { $v | Add-Member -NotePropertyName price -NotePropertyValue (Guess-Price $v) -Force }

# -------------------------------------------------------------------------
# 4) Optional AI pass (Groq --" free tier)
# -------------------------------------------------------------------------
$key = $env:GROQ_API_KEY
$keyFile = Join-Path $root 'groq.key'
if (-not $key -and (Test-Path -LiteralPath $keyFile)) { $key = (Get-Content -LiteralPath $keyFile -Raw).Trim() }
if (-not $key) {
    Line
    Write-Host '  An AI pass can fill in proper display names, brands, categories and'
    Write-Host '  realistic prices for every vehicle. It is optional and free.'
    Write-Host '  Get a key at https://console.groq.com  (or leave empty to skip)'
    $key = (Read-Host '  Groq API key').Trim()
    if ($key) {
        $save = (Read-Host '  Save it to groq.key for next time? (y/N)').Trim().ToLower()
        if ($save -eq 'y') { Set-Content -LiteralPath $keyFile -Value $key -Encoding ascii; Ok 'saved groq.key' }
    }
}

if ($key) {
    Line
    Info 'Asking the AI to clean up names / brands / categories / prices...'
    $cats = 'compacts, sedans, suvs, coupes, muscle, sportsclassics, sports, super, motorcycles, offroad, vans, commercial'
    $batch = 35
    for ($i = 0; $i -lt $vehicles.Count; $i += $batch) {
        $slice = $vehicles[$i..([math]::Min($i + $batch - 1, $vehicles.Count - 1))]
        $payload = $slice | ForEach-Object {
            @{ model = $_.model; name = $_.name; brand = $_.brand; category = $_.category; price = $_.price }
        }
        $sys = "You name and price vehicles for a FiveM roleplay car dealership. " +
               "For each vehicle you get its spawn code and whatever metadata the resource had. " +
               "Infer the REAL car it is (most FiveM addons are real-life cars) and return a clean " +
               "display name (e.g. 'M4 Competition'), the manufacturer as brand (e.g. 'BMW'), one " +
               "category from this list: $cats, and a realistic in-game price in dollars " +
               "(compacts 8k-25k, sedans 12k-60k, coupes 25k-120k, muscle 20k-150k, offroad 15k-120k, " +
               "sports 60k-400k, sportsclassics 80k-900k, super 250k-3500k, suvs 20k-250k, vans 8k-40k, " +
               "motorcycles 8k-150k, commercial 30k-150k). Keep the spawn code EXACTLY as given. " +
               "Answer ONLY with JSON: {""vehicles"":[{""model"":"""",""name"":"""",""brand"":"""",""category"":"""",""price"":0}]}"
        $body = @{
            model = 'llama-3.3-70b-versatile'
            temperature = 0.2
            response_format = @{ type = 'json_object' }
            messages = @(
                @{ role = 'system'; content = $sys },
                @{ role = 'user';   content = ($payload | ConvertTo-Json -Depth 4 -Compress) }
            )
        } | ConvertTo-Json -Depth 8
        try {
            $res = Invoke-RestMethod -Uri 'https://api.groq.com/openai/v1/chat/completions' -Method Post `
                    -Headers @{ Authorization = "Bearer $key" } -ContentType 'application/json; charset=utf-8' `
                    -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) -TimeoutSec 90
            $json = $res.choices[0].message.content | ConvertFrom-Json
            foreach ($r in @($json.vehicles)) {
                $m = ('' + $r.model).ToLower()
                $target = $vehicles | Where-Object { $_.model -eq $m } | Select-Object -First 1
                if (-not $target) { continue }
                if ($r.name)  { $target.name  = ('' + $r.name).Trim() }
                if ($r.brand) { $target.brand = ('' + $r.brand).Trim() }
                if ($r.category -and $BASEPRICE.ContainsKey(('' + $r.category).ToLower())) {
                    $target.category = ('' + $r.category).ToLower()
                }
                $p = 0
                if ([int]::TryParse(('' + $r.price), [ref]$p) -and $p -gt 0) { $target.price = $p }
            }
            Ok ("AI: {0}/{1}" -f ([math]::Min($i + $batch, $vehicles.Count)), $vehicles.Count)
        } catch {
            Warn "AI batch failed ($($_.Exception.Message)) - keeping the heuristic values."
        }
        Start-Sleep -Milliseconds 400
    }
} else {
    Info 'No AI key - using the heuristic names/prices from the meta files.'
}

# -------------------------------------------------------------------------
# 5) Output
# -------------------------------------------------------------------------
$out = Join-Path $root 'apex_import'
if (-not (Test-Path -LiteralPath $out)) { New-Item -ItemType Directory -Path $out | Out-Null }

function LuaStr($s) { return ("'" + (('' + $s) -replace "\\", "\\\\" -replace "'", "\'") + "'") }
function SqlStr($s) { return ("'" + (('' + $s) -replace "'", "''") + "'") }

$sorted = $vehicles | Sort-Object category, name
$resName = Split-Path $root -Leaf
$stamp = (Get-Date).ToString('yyyy-MM-dd HH:mm')

# vehicles.lua --" dropped in the RESOURCE ROOT so /dealerships > Import sees it
$lua = New-Object System.Text.StringBuilder
[void]$lua.AppendLine("--[[ Generated by the Apex Vehicle Importer - $stamp")
[void]$lua.AppendLine("     Resource: $resName")
[void]$lua.AppendLine("     $($vehicles.Count) vehicles ($($addon.Count) addon / $($replace.Count) replace)")
[void]$lua.AppendLine("     Import them in-game: /dealerships -> Import -> this resource ]]")
[void]$lua.AppendLine('')
[void]$lua.AppendLine('ApexVehicles = {')
foreach ($v in $sorted) {
    [void]$lua.AppendLine(("    {{ model = {0}, name = {1}, brand = {2}, category = {3}, price = {4} }},  -- {5}" -f `
        (LuaStr $v.model), (LuaStr $v.name), (LuaStr $v.brand), (LuaStr $v.category), $v.price, $v.kind))
}
[void]$lua.AppendLine('}')
[void]$lua.AppendLine('')
[void]$lua.AppendLine('return ApexVehicles')
$luaPath = Join-Path $root 'vehicles.lua'
if (Test-Path -LiteralPath $luaPath) {
    Copy-Item -LiteralPath $luaPath -Destination (Join-Path $out 'vehicles.lua.bak') -Force
    Warn 'existing vehicles.lua backed up to apex_import\vehicles.lua.bak'
}
Set-Content -LiteralPath $luaPath -Value $lua.ToString() -Encoding utf8

# SQL
$sql = New-Object System.Text.StringBuilder
[void]$sql.AppendLine("-- Apex Vehicle Importer - $stamp - resource: $resName")
[void]$sql.AppendLine('-- Run against your server DB to add these vehicles to the dealership catalog.')
[void]$sql.AppendLine('INSERT INTO `apex_dealerships_catalog` (`model`, `brand`, `name`, `category`, `price`) VALUES')
$rows = @()
foreach ($v in $sorted) {
    $rows += ("({0}, {1}, {2}, {3}, {4})" -f (SqlStr $v.model), (SqlStr $v.brand), (SqlStr $v.name), (SqlStr $v.category), $v.price)
}
[void]$sql.AppendLine(($rows -join ",`r`n"))
[void]$sql.AppendLine('ON DUPLICATE KEY UPDATE `brand` = VALUES(`brand`), `name` = VALUES(`name`), `category` = VALUES(`category`), `price` = VALUES(`price`);')
Set-Content -LiteralPath (Join-Path $out 'apex_vehicles.sql') -Value $sql.ToString() -Encoding utf8

# JSON
$sorted | Select-Object model, name, brand, category, price, kind |
    ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $out 'apex_vehicles.json') -Encoding utf8

# report
$rep = New-Object System.Text.StringBuilder
[void]$rep.AppendLine("APEX VEHICLE IMPORTER - $stamp")
[void]$rep.AppendLine("Resource: $resName")
[void]$rep.AppendLine(("Total: {0}   Addon: {1}   Replace: {2}   Skipped: {3}" -f $vehicles.Count, $addon.Count, $replace.Count, $skipped.Count))
[void]$rep.AppendLine('')
[void]$rep.AppendLine('== ADDON (new spawn codes - safe to sell) ==')
foreach ($v in ($addon | Sort-Object model)) { [void]$rep.AppendLine(('  {0,-24} {1} {2} [{3}] ${4}' -f $v.model, $v.brand, $v.name, $v.category, $v.price)) }
[void]$rep.AppendLine('')
[void]$rep.AppendLine('== REPLACE (overwrite a base-game car - it is probably ALREADY in your catalog) ==')
foreach ($v in ($replace | Sort-Object model)) { [void]$rep.AppendLine(('  {0,-24} {1} {2} [{3}] ${4}' -f $v.model, $v.brand, $v.name, $v.category, $v.price)) }
[void]$rep.AppendLine('')
[void]$rep.AppendLine('== SKIPPED (planes / boats / trailers / bikes-not-motorcycles) ==')
foreach ($s in ($skipped | Sort-Object model)) { [void]$rep.AppendLine(("  {0,-24} {1}" -f $s.model, $s.why)) }
Set-Content -LiteralPath (Join-Path $out 'report.txt') -Value $rep.ToString() -Encoding utf8

Line
Ok "vehicles.lua       -> $luaPath"
Ok "apex_vehicles.sql  -> $out\apex_vehicles.sql"
Ok "apex_vehicles.json -> $out\apex_vehicles.json"
Ok "report.txt         -> $out\report.txt"
Line
Write-Host '  NEXT STEPS' -ForegroundColor Blue
Write-Host '   1. In game (as admin): /dealerships  ->  Import tab'
Write-Host ("   2. Pick the source '{0} / vehicles.lua' and hit Import." -f $resName)
Write-Host '      (tick "Update existing vehicles" to overwrite prices/names of REPLACE cars)'
Write-Host '   3. The vehicles are now in the catalog - add their categories to a stand,'
Write-Host '      or build a curated Listing with exactly these cars.'
if ($replace.Count -gt 0) {
    Write-Host ''
    Warn ("{0} vehicle(s) REPLACE base-game cars - they already exist in the catalog." -f $replace.Count)
    Write-Host '         Import with "Update existing" if you want their new names/prices to win.'
}
Write-Host ''
