/**
 * Server-Side Resource Scanner
 * Scans all resource directories for .ymap, .ybn, .yocc, .ytyp files.
 * Detects duplicates and occlusion ymaps (files with 'occl' in the name).
 * Admin-only via txAdmin ACE permissions (works on any framework).
 */

const fs = require('fs');
const path = require('path');

// ═══════════════════════════════════════════
//  Admin Check — txAdmin ACE permissions
//  Universal: works on Qbox, QBCore, ESX, etc.
// ═══════════════════════════════════════════

function isAdmin(src) {
    const id = src.toString();
    return IsPlayerAceAllowed(id, 'command') || IsPlayerAceAllowed(id, 'txadmin.menu.server.kick');
}

// ═══════════════════════════════════════════
//  File Extension / Category Mapping
// ═══════════════════════════════════════════

const EXTENSION_MAP = {
    '.ymap': 'ymap',
    '.ybn': 'collision',
    '.yocc': 'occlusion',
    '.ytyp': 'ytyp',
};

const DOUBLE_EXTENSIONS = {
    '.ymap.xml': 'ymap',
    '.ybn.xml': 'collision',
    '.yocc.xml': 'occlusion',
    '.ytyp.xml': 'ytyp',
};

const CATEGORY_LABELS = {
    ymap: 'YMAPs',
    collision: 'Collisions',
    occlusion: 'Occlusions',
    ytyp: 'YTYPs',
};

function getCategoryFromPath(filePath) {
    const lower = filePath.toLowerCase();
    const baseName = path.basename(lower);

    for (const [ext, cat] of Object.entries(DOUBLE_EXTENSIONS)) {
        if (lower.endsWith(ext)) {
            if (ext === '.ymap.xml' && baseName.includes('occl')) return 'occlusion';
            return cat;
        }
    }
    for (const [ext, cat] of Object.entries(EXTENSION_MAP)) {
        if (lower.endsWith(ext)) {
            if (ext === '.ymap' && baseName.includes('occl')) return 'occlusion';
            return cat;
        }
    }
    return null;
}

function getBaseName(filePath) {
    let name = path.basename(filePath);
    name = name.replace(/\.ymap\.xml$/i, '').replace(/\.ybn\.xml$/i, '')
               .replace(/\.yocc\.xml$/i, '').replace(/\.ytyp\.xml$/i, '')
               .replace(/\.ymap$/i, '').replace(/\.ybn$/i, '')
               .replace(/\.yocc$/i, '').replace(/\.ytyp$/i, '');
    return name.toLowerCase();
}

// ═══════════════════════════════════════════
//  Filesystem Scanner
// ═══════════════════════════════════════════

function scanDirectory(dirPath) {
    const files = [];
    function walk(currentPath) {
        try {
            const entries = fs.readdirSync(currentPath, { withFileTypes: true });
            for (const entry of entries) {
                const fullPath = path.join(currentPath, entry.name);
                if (entry.isDirectory()) walk(fullPath);
                else if (entry.isFile()) files.push(fullPath);
            }
        } catch (err) {}
    }
    walk(dirPath);
    return files;
}

// ═══════════════════════════════════════════
//  Full Scan
// ═══════════════════════════════════════════

function performFullScan() {
    const results = { ymap: {}, collision: {}, occlusion: {}, ytyp: {} };
    let resourceCount = 0;
    let totalFiles = 0;
    let duplicateCount = 0;

    const numResources = GetNumResources();

    for (let i = 0; i < numResources; i++) {
        const resourceName = GetResourceByFindIndex(i);
        if (!resourceName || GetResourceState(resourceName) !== 'started') continue;

        resourceCount++;
        const resourcePath = GetResourcePath(resourceName);
        if (!resourcePath) continue;

        const foundInResource = {};
        const allFiles = scanDirectory(resourcePath);

        for (const fullFilePath of allFiles) {
            const category = getCategoryFromPath(fullFilePath);
            if (!category) continue;

            const baseName = getBaseName(fullFilePath);
            const relativePath = path.relative(resourcePath, fullFilePath);
            const uniqueKey = `${category}:${baseName}`;
            if (foundInResource[uniqueKey]) continue;
            foundInResource[uniqueKey] = true;

            if (!results[category][baseName]) results[category][baseName] = [];

            results[category][baseName].push({
                resource: resourceName,
                relativePath: relativePath.replace(/\\/g, '/'),
                fullPath: fullFilePath.replace(/\\/g, '/'),
                source: 'filesystem',
            });
            totalFiles++;
        }
    }

    for (const catKey of Object.keys(results)) {
        for (const entries of Object.values(results[catKey])) {
            const uniqueResources = new Set(entries.map(e => e.resource));
            if (uniqueResources.size > 1) duplicateCount++;
        }
    }

    return { files: results, stats: { resources: resourceCount, totalFiles, duplicates: duplicateCount } };
}

// ═══════════════════════════════════════════
//  Build Report for NUI
// ═══════════════════════════════════════════

function buildReport(scanData) {
    const report = { stats: scanData.stats, categories: [] };

    for (const [catKey, catLabel] of Object.entries(CATEGORY_LABELS)) {
        const catReport = { key: catKey, label: catLabel, totalFiles: 0, duplicates: [], allFiles: [] };
        const catFiles = scanData.files[catKey] || {};

        for (const [baseName, entries] of Object.entries(catFiles)) {
            catReport.totalFiles += entries.length;
            const uniqueResources = new Set(entries.map(e => e.resource));
            const isDuplicate = uniqueResources.size > 1;

            for (const entry of entries) {
                catReport.allFiles.push({
                    name: baseName, resource: entry.resource,
                    relativePath: entry.relativePath, fullPath: entry.fullPath,
                    source: entry.source, isDuplicate,
                });
            }

            if (isDuplicate) {
                catReport.duplicates.push({
                    name: baseName, count: entries.length,
                    resourceCount: uniqueResources.size,
                    sources: entries.map(e => ({
                        resource: e.resource, relativePath: e.relativePath,
                        fullPath: e.fullPath, source: e.source,
                    })),
                });
            }
        }

        catReport.duplicates.sort((a, b) => b.count - a.count);
        catReport.allFiles.sort((a, b) => {
            if (a.name === b.name) return a.resource.localeCompare(b.resource);
            return a.name.localeCompare(b.name);
        });
        report.categories.push(catReport);
    }

    report.categories.sort((a, b) => a.label.localeCompare(b.label));
    return report;
}

// ═══════════════════════════════════════════
//  Event Handlers
// ═══════════════════════════════════════════

onNet('mapscanner:checkAccess', () => {
    const src = global.source;
    if (isAdmin(src)) {
        emitNet('mapscanner:accessGranted', src);
    }
});

onNet('mapscanner:requestScan', () => {
    const src = global.source;
    if (!isAdmin(src)) { emitNet('mapscanner:accessDenied', src); return; }

    const startTime = Date.now();
    const scanData = performFullScan();
    const report = buildReport(scanData);
    const elapsed = Date.now() - startTime;

    console.log(`[MapScanner] Scan complete in ${elapsed}ms: ${report.stats.resources} resources, ${report.stats.totalFiles} map files, ${report.stats.duplicates} duplicates`);

    emitNet('mapscanner:scanResults', src, report);
});

console.log('[MapScanner] Server scanner loaded. Admin-only via txAdmin permissions.');
