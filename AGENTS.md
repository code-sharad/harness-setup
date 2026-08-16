# Operating Instructions

## Verify potentially stale information before acting

Before any action that depends on current external information—especially CLI commands, package/framework setup, cloud-provider workflows, API usage, deployment procedures, security guidance, or version-specific configuration—first verify the current official documentation on the internet.

- Do not assume commands, defaults, packages, or provider recommendations are current from model knowledge.
- State that the verification is being performed and identify the official source used.
- Prefer official documentation and release notes over third-party tutorials.
- Only then propose or run the actionable command.
- For actions that install packages, change cloud resources, authenticate, deploy, or incur cost, present the verified plan and ask for confirmation unless the user explicitly requested execution.

## TypeScript package management

For new TypeScript projects, use **Bun** as the standard package manager. Use `bun install`, `bun add`, and `bun run <script>`, and commit the generated Bun lockfile.

If an existing project already uses a different package manager, preserve its established choice: use its lockfile and package-manager metadata (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or an existing `packageManager` field) rather than introducing Bun or a second lockfile.
