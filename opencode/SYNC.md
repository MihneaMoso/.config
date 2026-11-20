# OpenCode configuration Git sync

Manual, Git-only synchronization of global OpenCode configuration between the
desktop and the laptop. No automation, no background services, no credential
syncing.

## Architecture

Desktop (source of truth, unchanged):

```
~/.config/
├── opencode/          <- normal directory inside the full ~/.config repo
├── fish/
├── nvim/
└── .git/              <- github.com/MihneaMoso/.config (branch: master)
```

Laptop:

```
~/.config/
├── opencode -> ~/.local/share/opencode-config/opencode     (symlink)
├── <other apps, untouched>
└── .git/              <- the laptop's OWN, unrelated config repo

~/.local/share/opencode-config/     <- separate sparse clone of the same GitHub repo
├── .git/
└── opencode/                        <- the only directory checked out
```

OpenCode reads `~/.config/opencode` on both machines. On the laptop that path is
a symlink into the sparse clone; the laptop's existing `~/.config` repository and
all of its other application configs are never touched.

The sparse clone keeps the repository root as its checkout root, so the config
files live at `~/.local/share/opencode-config/opencode/`. That is why the symlink
target includes the trailing `/opencode`.

Sparse-checkout patterns are stored in the laptop clone at
`.git/info/sparse-checkout` (non-cone mode).

## Files that are synchronized

Anything portable under `opencode/`:

- `opencode.jsonc` and `opencode.json` (providers, models, default model, agents)
- `cli.json` (theme, TUI/session preferences)
- `AGENTS.md`, `CLAUDE.md`
- `agents/`, `commands/`, `plugins/`, `themes/`, `skills/`
- this `SYNC.md`
- any future portable file added under `opencode/`

Current custom providers: `apinex` (9 models) and `centai` (19 models). API keys
are referenced with `{env:...}` placeholders, so no secrets live in these files.

## Files that stay local

- `service.json` — machine-generated service password/route state. Excluded from
  the laptop checkout by the sparse-checkout pattern. OpenCode regenerates it;
  never commit it.
- `opencode/.gitignore`, `package.json`, `package-lock.json`, `node_modules/` —
  local dependency install, already ignored on the desktop.
- `~/.local/share/opencode/` — sessions, SQLite DB, logs, caches, service state.
  Never synced.
- Environment variables (`APINEX_API_KEY`, `CENT_AI_KEY`, etc.) — set these
  separately on each machine.

## Pull changes

Desktop:

```bash
cd ~/.config
git fetch
git pull --ff-only
```

Laptop (run these in the sparse clone, NOT in `~/.config`):

```bash
cd ~/.local/share/opencode-config
git fetch
git pull --ff-only
```

## Push changes

Desktop:

```bash
cd ~/.config
git add opencode
git restore --staged opencode/service.json
git commit -m "Update OpenCode configuration"
git push
```

Laptop (add portable paths explicitly so a local `service.json` is never staged):

```bash
cd ~/.local/share/opencode-config
git add opencode/opencode.jsonc opencode/cli.json    # add any other changed portable files too
git commit -m "Update OpenCode configuration (laptop)"
git push
```

Never force-push, never `git reset --hard`, never `git clean -fd`.

## Resolving conflicts

1. `git status` — find the file listed under "both modified".
2. Open it, keep the correct lines, and remove the `<<<<<<<`, `=======` and
   `>>>>>>>` markers.
3. `git add <file>`
4. `git commit`
5. `git fetch && git pull --ff-only` again if needed, then `git push`.

If a pull refuses because of unrelated local edits (fish, htop, nvim, etc.),
commit or stash those first. Do not discard them.

## Setting up another device

Requires a fresh or disposable `~/.config/opencode` on that device.

```bash
git clone --filter=blob:none --sparse \
  https://github.com/MihneaMoso/.config \
  ~/.local/share/opencode-config

cd ~/.local/share/opencode-config
git sparse-checkout set --no-cone '/*' '!/*/' '/opencode/' '!/opencode/service.json'
git ls-files | head          # sanity check: opencode.jsonc present, service.json absent

# only if a fresh ~/.config/opencode already exists and you intend to replace it:
rm -rf ~/.config/opencode
ln -s ~/.local/share/opencode-config/opencode ~/.config/opencode

opencode models              # apinex/... and centai/... should be listed
```

If the clone is not on the right branch: `git switch master`.

## Disabling sync and restoring the original layout

Laptop:

```bash
rm ~/.config/opencode                     # remove ONLY the symlink
mkdir -p ~/.config/opencode
# copy back whichever portable files you want to keep as normal local files:
cp ~/.local/share/opencode-config/opencode/opencode.jsonc ~/.config/opencode/
cp ~/.local/share/opencode-config/opencode/cli.json       ~/.config/opencode/
# optionally remove the clone when you no longer need it:
rm -rf ~/.local/share/opencode-config
```

Desktop: nothing to undo — `~/.config/opencode` was always a normal directory in
the main repository. To stop syncing, just stop committing changes under
`opencode/` and delete this file.
