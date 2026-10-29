const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const MAP_EXT = new Set(['.ymap', '.ybn', '.ytyp', '.ydr', '.ydd', '.ymf']);
const IGNORE = new Set(['_manifest.ymf']);
const OWN_MARKERS = new Set(['tw_const.ytyp', 'tw_garage.ytyp', 'tw_billboard.ytyp']);

function isOwnMarker(name) {
    return name.startsWith('tworst_') || OWN_MARKERS.has(name);
}

function isOwnAsset(name) {
    return name.startsWith('tworst_') || name.startsWith('tw_') || name === 'tw.ytyp';
}

function computeConflicts(resources) {
    const own = resources.filter((r) => r.files.some((f) => isOwnMarker(f.name)));
    const ownNames = new Set(own.map((r) => r.resource));
    const vanilla = new Map();
    for (const r of own) {
        for (const f of r.files) {
            if (isOwnAsset(f.name) || IGNORE.has(f.name)) continue;
            if (!vanilla.has(f.name)) vanilla.set(f.name, []);
            vanilla.get(f.name).push({ resource: r.resource, size: f.size, hash: f.hash });
        }
    }

    const foreign = [];
    for (const r of resources) {
        if (ownNames.has(r.resource)) continue;
        const hits = [];
        for (const f of r.files) {
            const mine = vanilla.get(f.name);
            if (mine) hits.push({ file: f.name, ours: mine[0].resource });
        }
        if (hits.length) foreign.push({ resource: r.resource, hits });
    }

    const selfDiff = [];
    for (const [name, copies] of vanilla) {
        if (copies.length < 2) continue;
        const first = copies[0];
        const differs = copies.some((c) => c.size !== first.size || (c.hash && first.hash && c.hash !== first.hash));
        if (differs) selfDiff.push({ file: name, resources: copies.map((c) => c.resource) });
    }

    return { own: [...ownNames], foreign, selfDiff };
}

function walk(dir, out, depth) {
    if (depth > 10) return;
    let entries;
    try {
        entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch (e) {
        return;
    }
    for (const e of entries) {
        const full = path.join(dir, e.name);
        if (e.isDirectory()) {
            walk(full, out, depth + 1);
        } else if (MAP_EXT.has(path.extname(e.name).toLowerCase())) {
            out.push({ name: e.name.toLowerCase(), full });
        }
    }
}

function scanServer() {
    const resources = [];
    const count = GetNumResources();
    for (let i = 0; i < count; i++) {
        const name = GetResourceByFindIndex(i);
        if (!name || GetResourceState(name) !== 'started') continue;
        const root = GetResourcePath(name);
        if (!root) continue;
        const found = [];
        walk(path.join(root, 'stream'), found, 0);
        if (found.length) resources.push({ resource: name, files: found });
    }

    const own = new Set(resources.filter((r) => r.files.some((f) => isOwnMarker(f.name))).map((r) => r.resource));
    for (const r of resources) {
        r.files = r.files.map((f) => {
            const entry = { name: f.name, size: 0 };
            if (own.has(r.resource) && !isOwnAsset(f.name) && !IGNORE.has(f.name)) {
                try {
                    const buf = fs.readFileSync(f.full);
                    entry.size = buf.length;
                    entry.hash = crypto.createHash('md5').update(buf).digest('hex');
                } catch (e) {
                    entry.size = -1;
                }
            }
            return entry;
        });
    }

    const result = computeConflicts(resources);
    result.scanned = resources.length;
    return result;
}

if (typeof exports === 'function') {
    exports('twMapFileScan', scanServer);
} else if (typeof module !== 'undefined') {
    module.exports = { computeConflicts, isOwnMarker, isOwnAsset };
}
