#!/usr/bin/env node
// PostToolUse hook for Edit/Write: formats edited .dart files and flags
// privacy issues (AGENTS.md §1.3) in lib/. Exit code 2 sends stderr back to Claude.
'use strict';

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

let raw = '';
process.stdin.on('data', (chunk) => (raw += chunk));
process.stdin.on('end', () => {
  let input;
  try {
    input = JSON.parse(raw);
  } catch {
    process.exit(0);
  }

  const filePath = input?.tool_input?.file_path;
  if (typeof filePath !== 'string' || !filePath.endsWith('.dart') || !fs.existsSync(filePath)) {
    process.exit(0);
  }

  try {
    execFileSync('dart', ['format', filePath], { stdio: 'ignore', shell: process.platform === 'win32' });
  } catch {
    // Syntax errors make dart format fail; flutter analyze will report them.
  }

  const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const rel = path.relative(projectDir, filePath).split(path.sep).join('/');
  if (!rel.startsWith('lib/')) process.exit(0);

  const warnings = [];
  const lines = fs.readFileSync(filePath, 'utf8').split(/\r?\n/);
  lines.forEach((line, i) => {
    const code = line.replace(/\/\/.*$/, '');
    if (/\b(print|debugPrint)\s*\(/.test(code)) {
      warnings.push(`${rel}:${i + 1} print/debugPrint — PII veya hassas içerik loglanmamalı (AGENTS.md §1.3)`);
    }
    if (/(api[_-]?key|secret|password|token)\s*[:=]\s*['"][^'"]{8,}['"]/i.test(code) ||
        /['"](sk-[A-Za-z0-9]{16,}|AIza[0-9A-Za-z_-]{20,})['"]/.test(code)) {
      warnings.push(`${rel}:${i + 1} olası hardcoded sır — kaynak koda gömülemez (rules/dart/security.md §1)`);
    }
  });
  if (rel.startsWith('lib/ui/') && lines.some((l) => /import\s+['"][^'"]*services\//.test(l))) {
    warnings.push(`${rel}: UI katmanı services/ import ediyor — veri akışı providers/ üzerinden olmalı (AGENTS.md §1.5)`);
  }

  if (warnings.length > 0) {
    process.stderr.write(`GHARAR kural uyarıları:\n- ${warnings.join('\n- ')}\n`);
    process.exit(2);
  }
  process.exit(0);
});
