# Reproduction: avo-hq/avo#4301 — Avo crashes when gems load before Rails

Reproduces **[avo-hq/avo#4301](https://github.com/avo-hq/avo/issues/4301)** using
Puma in cluster (fork) mode as a stand-in for Sidekiq Enterprise's `sidekiqswarm`.

## The bug

`avo-dashboards` (included transitively through `avo-advanced` → `avo-pro`) requires
`Rails::Engine` at **file load time** without guarding it with `if defined?(Rails)`.
When any pre-forking server loads gems into the master process *before* Rails has
booted — to share memory pages across workers via **COW (Copy-on-Write)** — the load
crashes with:

```
uninitialized constant Rails (NameError)

    class Engine < ::Rails::Engine
                   ^^^^^^^
```

**Affected file:** `avo-dashboards/lib/avo/dashboards.rb`

```ruby
# avo-dashboards 3.30.1 (BUGGY)
require "avo/dashboards/engine"   # no Rails guard — crashes immediately

loader.eager_load                  # also no Rails guard
```

```ruby
# avo-dashboards 3.30.2 (FIXED — PR #4328)
require "avo/dashboards/engine" if defined?(Rails)
loader.eager_load if defined?(Rails)
```

## Why fork mode triggers this

Both `sidekiqswarm` and Puma in cluster mode follow the same pattern:

```
master process
  │
  ├─ Step 1: call Bundler.require (load all gems into memory for COW)
  │          ← CRASH HERE with avo 3.30.1 — Rails not yet available
  │
  ├─ Step 2: fork worker processes
  │
  └─ Worker: boot Rails, serve requests / process jobs
```

Memory is only shared between master and workers for pages that were
**loaded before** the fork. This is why production environments call
`Bundler.require` (or require specific gems) in the master process
before forking.

## Setup

```bash
bundle install
```

## Reproducing the crash

### Option 1 — isolated script (recommended)

Runs in a subprocess that has avo gems on its load path but **no Rails**,
exactly replicating the master process in a fork-mode server:

```bash
bundle exec bin/repro_isolated
```

Expected output:

```
============================================================
Reproducing avo-hq/avo#4301
============================================================

Spawning subprocess that loads avo-dashboards WITHOUT Rails...
(This simulates a Puma fork master or sidekiqswarm pre-loading gems)

Rails defined before require: nil
Loading avo-dashboards...
/usr/local/bundle/gems/avo-dashboards-3.30.1/lib/avo/dashboards/engine.rb:3:
  uninitialized constant Rails (NameError)
    class Engine < ::Rails::Engine
                   ^^^^^^^

✗ Crash confirmed — the bug is present in this Avo version.
```

### Option 2 — Puma cluster mode

Run Puma with multiple workers. The `WEB_CONCURRENCY` variable enables cluster
(fork) mode, which is the production pattern that exposes this class of bug:

```bash
WEB_CONCURRENCY=2 bundle exec puma
```

> **Note:** Puma's `config/environment.rb` loads Rails before the fork happens,
> so the Puma process itself starts successfully. The crash is most reliably
> reproduced via `bin/repro_isolated` (Option 1), which isolates the exact
> failure condition: loading avo gems without Rails on the load path.

### Option 3 — one-liner

Equivalent to what the issue reporter runs:

```bash
bundle exec ruby -e "
  \$LOAD_PATH.unshift(*Gem.loaded_specs.values_at('avo-dashboards', 'avo',
    'zeitwerk', 'activesupport').flat_map(&:load_paths))
  require 'zeitwerk'
  require 'active_support'
  require 'avo/dashboards'
  puts 'OK'
"
```

## Verifying the fix

Change the Gemfile to use the patched version:

```diff
- gem "avo-advanced", "3.30.1"
+ gem "avo-advanced", "3.30.2"
```

Then:

```bash
bundle update avo-advanced
bundle exec bin/repro_isolated
```

Expected output with the fix:

```
OK — No error. The issue appears to be fixed in this version.

✓ No crash — gem loaded successfully.
```

## Versions

| Component      | Version |
|----------------|---------|
| Ruby           | 4.0.x   |
| Rails          | 8.0.x   |
| avo-advanced   | 3.30.1  |
| avo-dashboards | 3.30.1  |

## Root cause

`avo-dashboards/lib/avo/dashboards.rb` in 3.30.1 unconditionally requires the
engine and eager-loads the gem at file load time:

```ruby
require "avo/dashboards/engine"   # executed unconditionally

loader.eager_load                  # executed unconditionally
```

`avo/dashboards/engine.rb` then references `Rails::Engine`:

```ruby
class Engine < ::Rails::Engine   # Rails must already be defined
```

The fix (3.30.2) adds `if defined?(Rails)` guards:

```ruby
require "avo/dashboards/engine" if defined?(Rails)
loader.eager_load if defined?(Rails)
```

## Related

- [avo-hq/avo#4301](https://github.com/avo-hq/avo/issues/4301) — original issue
- [avo-hq/avo#4323](https://github.com/avo-hq/avo/pull/4323) — fix for `AssetManager`
- [avo-hq/avo#4328](https://github.com/avo-hq/avo/pull/4328) — fix for `avo-dashboards`
