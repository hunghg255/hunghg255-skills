---
name: ai-git-commit
description: Commit code created or modified by AI with the dedicated Git identity hunghg255bot and giahunghustbot@gmail.com, without changing repository or global Git configuration. Use when the user invokes $ai-git-commit, asks to commit the current AI-generated changes, or wants an AI-authored conventional commit attributed to hunghg255bot.
---

# AI Git Commit

Create a Conventional Commit for AI-generated changes. Apply the bot identity to that commit only; preserve every persistent Git configuration value.

## Identity

Use exactly:

- Name: `hunghg255bot`
- Email: `giahunghustbot@gmail.com`

Never run `git config`, including with `--local`, `--global`, or `--system`.

## Workflow

1. Confirm the current directory is inside a Git worktree with `git rev-parse --show-toplevel`.
2. Inspect `git status --short`, `git diff`, and `git diff --staged`.
3. Treat changes produced by the current AI task as AI-authored. Explicit invocation also means the user intends the selected changes to use the bot identity.
4. If changes from unrelated work are present, preserve them. Use already staged changes when they form one logical unit; otherwise stage only the relevant paths with `git add -- <path>...`. Never use `git add -A` blindly.
5. Check relevant files for likely secrets such as `.env`, credentials, API keys, tokens, and private keys. Do not stage suspected secrets.
6. Run focused verification appropriate to the change when practical.
7. Generate a Conventional Commit message in imperative mood with a concise subject:

   ```text
   <type>[optional scope]: <description>
   ```

8. Commit with the one-command identity override:

   ```bash
   git -c user.name="hunghg255bot" \
       -c user.email="giahunghustbot@gmail.com" \
       commit -m "<message>"
   ```

   Do not use `--author`; the `-c` overrides intentionally apply the bot identity to both author and committer for this one Git process.

9. Verify the recorded identity and summarize the result:

   ```bash
   git log -1 --format='%h%n%an <%ae>%n%cn <%ce>%n%s'
   git status --short
   ```

   Both author and committer must be `hunghg255bot <giahunghustbot@gmail.com>`.

## Commit Types

- `feat`: new behavior
- `fix`: bug fix
- `docs`: documentation only
- `style`: formatting without behavior changes
- `refactor`: restructuring without a feature or fix
- `perf`: performance improvement
- `test`: tests only
- `build`: build system or dependencies
- `ci`: CI configuration
- `chore`: maintenance
- `revert`: revert a prior commit

## Safety

- Keep one logical change per commit.
- Never modify persistent Git identity or other Git configuration.
- Never use destructive reset, force options, or `--no-verify` unless the user explicitly requests it.
- If a hook fails, report or fix the underlying issue as appropriate, then create a new commit attempt; do not amend an existing commit unless explicitly requested.
- Do not push unless the user explicitly asks.
