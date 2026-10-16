#!/usr/bin/env node
/**
 * everything-bob CLI test suite
 * Validates skills, hooks, agents, and modes without external dependencies.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const CLI = path.join(ROOT, 'bin', 'everything-bob');
let pass = 0, fail = 0;

function test(name, fn) {
  try { fn(); console.log(`  ✔ ${name}`); pass++; }
  catch (e) { console.log(`  ✖ ${name}: ${e.message}`); fail++; }
}

function assert(condition, msg) {
  if (!condition) throw new Error(msg || 'assertion failed');
}

console.log('\n🧪 Everything Bob Test Suite\n');

// ── Skills validation ─────────────────────────────────────────────────────────
console.log('Skills:');
const skillsDir = path.join(ROOT, 'skills');
const skills = fs.readdirSync(skillsDir).filter(s => fs.statSync(path.join(skillsDir, s)).isDirectory());
assert(skills.length >= 30, `Expected ≥30 skills, found ${skills.length}`);
console.log(`  (${skills.length} skills found)`);

for (const s of skills) {
  test(`skills/${s}/SKILL.md — valid frontmatter`, () => {
    const md = path.join(skillsDir, s, 'SKILL.md');
    assert(fs.existsSync(md), 'SKILL.md missing');
    const content = fs.readFileSync(md, 'utf8');
    assert(content.startsWith('---'), 'missing frontmatter start');
    const parts = content.split('---');
    assert(parts.length >= 3, 'malformed frontmatter');
    const fm = parts[1];
    assert(/name:\s*\S+/.test(fm), 'missing name field');
    assert(/description:\s*.+/s.test(fm), 'missing description field');
    // Name should match directory
    const nameMatch = fm.match(/name:\s*([^\n\r]+)/);
    assert(nameMatch && nameMatch[1].trim() === s, `name '${nameMatch?.[1]?.trim()}' does not match directory '${s}'`);
  });
}

// ── Hooks validation ───────────────────────────────────────────────────────────
console.log('\nHooks:');
const hooksDir = path.join(ROOT, 'hooks');
const hooks = fs.readdirSync(hooksDir).filter(h => fs.statSync(path.join(hooksDir, h)).isDirectory());
assert(hooks.length >= 7, `Expected ≥7 hooks, found ${hooks.length}`);

for (const h of hooks) {
  test(`hooks/${h}/hooks.json — valid JSON`, () => {
    const hf = path.join(hooksDir, h, 'hooks.json');
    assert(fs.existsSync(hf), 'hooks.json missing');
    const parsed = JSON.parse(fs.readFileSync(hf, 'utf8'));
    assert(typeof parsed === 'object' && parsed !== null, 'not an object');
  });

  test(`hooks/${h}/scripts — executable`, () => {
    const scriptsDir = path.join(hooksDir, h, 'scripts');
    if (!fs.existsSync(scriptsDir)) return; // no scripts required
    const scripts = fs.readdirSync(scriptsDir).filter(f => f.endsWith('.sh'));
    for (const s of scripts) {
      const stat = fs.statSync(path.join(scriptsDir, s));
      assert(stat.mode & 0o111, `${s} is not executable`);
    }
  });
}

// ── Agents validation ──────────────────────────────────────────────────────────
console.log('\nAgents:');
const agentsDir = path.join(ROOT, 'agents');
const agents = fs.readdirSync(agentsDir).filter(f => f.endsWith('.md'));
assert(agents.length >= 8, `Expected ≥8 agents, found ${agents.length}`);
for (const a of agents) {
  test(`agents/${a} — has content`, () => {
    const content = fs.readFileSync(path.join(agentsDir, a), 'utf8');
    assert(content.length > 200, 'agent spec too short');
    assert(content.includes('Role'), 'missing Role section');
  });
}

// ── Modes validation ───────────────────────────────────────────────────────────
console.log('\nModes:');
test('modes/custom_modes.yaml — exists and has entries', () => {
  const modesFile = path.join(ROOT, 'modes', 'custom_modes.yaml');
  assert(fs.existsSync(modesFile), 'custom_modes.yaml missing');
  const content = fs.readFileSync(modesFile, 'utf8');
  const slugs = (content.match(/slug:\s*\S+/g) || []);
  assert(slugs.length >= 5, `Expected ≥5 modes, found ${slugs.length}`);
  // Check no duplicate slugs
  const slugNames = slugs.map(s => s.replace('slug:', '').trim());
  const unique = new Set(slugNames);
  assert(unique.size === slugNames.length, 'duplicate slugs found in custom_modes.yaml');
});

// ── Templates validation ───────────────────────────────────────────────────────
console.log('\nTemplates:');
for (const t of ['minimal', 'recommended', 'full-power']) {
  test(`templates/${t}/hooks.json — valid JSON`, () => {
    const tf = path.join(ROOT, 'templates', t, 'hooks.json');
    assert(fs.existsSync(tf), `${t}/hooks.json missing`);
    JSON.parse(fs.readFileSync(tf, 'utf8'));
  });
}

// ── CLI tests ─────────────────────────────────────────────────────────────────
console.log('\nCLI:');
test('bin/everything-bob — executable', () => {
  assert(fs.existsSync(CLI), 'CLI binary missing');
  const stat = fs.statSync(CLI);
  assert(stat.mode & 0o111, 'CLI not executable');
});

test('everything-bob version — outputs version string', () => {
  const out = execSync(`node "${CLI}" version`, { encoding: 'utf8' }).trim();
  assert(/^\d+\.\d+\.\d+$/.test(out), `unexpected version output: ${out}`);
});

test('everything-bob test-all — runs without crash', () => {
  execSync(`node "${CLI}" test-all --json`, { encoding: 'utf8' });
});

// ── Summary ───────────────────────────────────────────────────────────────────
console.log(`\n${'─'.repeat(50)}`);
console.log(`Tests: ${pass + fail} total  ✔ ${pass} passed  ${fail > 0 ? '✖ ' + fail + ' failed' : ''}`);
if (fail > 0) process.exit(1);
else console.log('\n✨ All tests passed!\n');
