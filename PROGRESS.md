# Terraform Associate (004) — Progress

- **Target:** HashiCorp Certified: Terraform Associate **(004)** — exam week of **2026-12-15** (delivered by Certiverse).
- **Note:** 003 was retired on 2026-01-07. The 004 exam tests **Terraform 1.12**; this lab runs **1.16.6**.
- **Cadence:** Tue & Wed 06:45–07:45 · Sun 10:00–12:00 · occasional 2 h block on a day off. One `.tf` file (or module) committed per session.
- **Status legend:** ⬜ To do · 🟨 Seen · ✅ Mastered · a ticked sub-objective = practiced hands-on at least once

## Session log

| # | Date | Duration | Covered | Folder |
|---|------|----------|---------|--------|
| 1 | 2026-10-20 | 60 min | Installed Terraform 1.16.6 (HashiCorp APT repo) + VS Code extension in WSL; read the 004 objectives; first project: `local_file` with the `local` provider (v2.9.1), full cycle fmt → init → validate → plan → apply → state list/show → destroy; read the state file line by line | `01-local-file/` |
| 2 | 2026-10-20 | 40 min (bonus, evening) | Two providers (`local` 2.9.1 + `random` 3.9.1); `random_pet` → `local_file` implicit dependency; variable `greeting` + 2 outputs; idempotency ("No changes"); `-var` triggers `-/+` replacement (`# forces replacement`); variable precedence experiment (tfvars / `TF_VAR_` / `-var`) | `02-random-local/` |
| 3 | 2026-10-20 | 30 min (bonus, evening) | State refactoring: `moved` block (rename `local_file.hello` → `greeting` with 0 to add/destroy); drift (file edited by hand → `local_file` seen as deleted → `+ create`); `removed` block with `destroy = false` (object kept on disk, dropped from state, "Removed resource still exists" error when the resource block is still there) | `03-state-refactor/` |
| 4 | 2026-10-21 | 60 min | `map(object)` variable; `for_each` (addresses `local_file.service["fhir"]`); `for` expression with `if` filter in `locals`; data source `local_file` reading a hand-made file; functions `join`, `trimspace`, `length`; `count` vs `for_each` experiment (removing a middle item shifts `count` indexes); `$( )` is bash, HCL interpolation is `${ }` | `04-collections/` |
| 5 | 2026-10-23 | 2 h (day off) | New in 004: `depends_on` (hidden dependency), `create_before_destroy` (`-/+` → `+/-`, "deposed object"), `prevent_destroy` (blocks the whole run), `ignore_changes`; variable `validation`, `precondition`, `postcondition` with `self`, `check` block (warning only); `sensitive` variable/output (hidden in CLI, plain text in state and with `output -raw`); ephemeral `random_password` (opened/closed each run, never in state, rejected in `content`: not a write-only attribute) | `05-lifecycle/` |
| 6 | 2026-10-23 | 25 min (day off, after session 5) | First child module `modules/service-file` (variables / main / outputs, heredoc content, `path.root`), called twice from the root; module addresses `module.fhir.local_file.this`; traps: parent can't read child resources (only outputs), `version` only for registry modules | `06-modules/` |

## Quiz log

| Session | Date | Score | Missed |
|---------|------|-------|--------|
| 1 | 2026-10-20 | 4/5 | Q4 sensitive values are stored in plain text in state |
| 2 | 2026-10-20 | 4/5 | Q4 `output` (not `variable`) exposes values and passes them from child to parent module |
| 3 | 2026-10-20 | 4/5 | Q4 accept drift into state without changing infra = `terraform apply -refresh-only` (`terraform refresh` is deprecated) |
| 6b | 2026-10-23 | 5/5 | — (re-quiz on modules right after the explanations; incl. private registry `app.terraform.io/acme/app/azurerm` accepts `version`) |
| 6 | 2026-10-23 | 1/5 | Q2 registry source = `<NAMESPACE>/<NAME>/<PROVIDER>` · Q3 parent reads `module.<call>.<output>` only · Q4 Git module pinned with `?ref=<tag>`, not `version` · Q5 child variable without default not set → error (end of a 2 h block: fatigue) |
| 5 | 2026-10-23 | 4/5 | Q3 a failing `check` assertion = warning, apply continues (and Terraform never rolls back) |
| 4 | 2026-10-21 | 3/5 | Q2 unordered unique values = `set` (not `map`) · Q3 `count`: removing a middle item → `[1]` replaced + `[2]` destroyed, `[0]` untouched (not "all recreated") |

## Exam objectives — status

| # | Domain | Status |
|---|--------|--------|
| 1 | Infrastructure as Code (IaC) with Terraform | 🟨 Seen (concepts known from Ansible/DevOps) |
| 2 | Terraform fundamentals | 🟨 Seen (session 1) |
| 3 | Core Terraform workflow | 🟨 Seen (session 1) |
| 4 | Terraform configuration | 🟨 Seen (sessions 2, 4, 5: all of 4a–4h practiced) |
| 5 | Terraform modules | 🟨 Seen (session 6: quiz 1/5, re-quiz 5/5; next: `for_each` on modules, Git source with `?ref`) |
| 6 | Terraform state management | 🟨 Seen (session 3: 6a, 6d) |
| 7 | Maintain infrastructure with Terraform | ⬜ To do |
| 8 | HCP Terraform | ⬜ To do |

## To review

- **Domain 2 – Terraform fundamentals:** no hands-on experience yet (self-assessment, 2026-10-20).
- **Domain 3 – Core workflow:** same.
- **Domain 6 – State management:** same.
- **Domain 8 – HCP Terraform:** same.
- **New in 004 (not in 003):** 4f `depends_on` / `create_before_destroy`, 4g custom conditions, 4h ephemeral values & write-only arguments, 8c HCP Terraform workspaces & projects. Many prep courses are still 003-based, so check these 4 topics explicitly.
- **Version constraints** (session 1): wrote `>= 2.5` instead of `~> 2.5`. `~>` lets only the rightmost written number move: `~> 2.5` = `>= 2.5, < 3.0`; `~> 2.5.0` = `>= 2.5.0, < 2.6.0`. Right in quiz 1 (Q2); keep checking it in your own code.
- **Provider source address** (session 1): `[HOSTNAME/]NAMESPACE/TYPE`, default hostname `registry.terraform.io` (typo `hasicorp` → init failed).
- **Resource type = provider local name + `_` + type** (session 1): wrote `resource "local"` instead of `resource "local_file"` → caught by `validate`.
- **Saved plans:** `terraform plan -out=tfplan` then `terraform apply tfplan` applies exactly that plan, with no prompt.
- **`terraform fmt`** only formats the current directory; use `-recursive` for subfolders.
- **Modules — all of it** (quiz 6: 1/5): sources = local `./` or `../` (no version) · public registry `<NAMESPACE>/<NAME>/<PROVIDER>` (e.g. `terraform-aws-modules/vpc/aws`) + `version` · private registry `<HOST>/<ORG>/<NAME>/<PROVIDER>` · Git `git::…?ref=<tag>` · the parent sees a module **only through its outputs** (`module.<call>.<output>`) · a child variable without default is **required** → error if the module block doesn't set it (the parent's variables are never inherited).
- **Custom conditions** (missed in quiz 5, Q3, after seeing it live): `validation`, `precondition`, `postcondition` → **error**, the run stops · `check` → **warning**, the run continues. And Terraform **never** rolls back.
- **Sensitive vs ephemeral** (session 5): `sensitive` hides in CLI output only (state, `output -raw`, `output -json` show plain text) · `ephemeral` is never stored (plan or state) and only fits write-only arguments (`*_wo` + `*_wo_version`), provider blocks, other ephemeral values.
- **Types** (missed in quiz 4, Q2): `list` = ordered, index from 0, duplicates OK · `map` = `{ key = value }`, string keys · `set` = unordered, unique values, no index, no keys · `object` = named attributes with their own types · `tuple` = ordered positions with their own types.
- **`count` vs `for_each`** (missed in quiz 4, Q3, right after doing the experiment): `count` identifies instances by position → removing a middle item shifts the following indexes (replace + destroy), earlier ones untouched. `for_each` identifies by key → only the removed key is destroyed.
- **Interpolation** (session 4): `${ }` only inside quotes; never `$( )` (bash) and never `${ }` nested inside `${ }`. A bare expression needs no quotes. `validate` doesn't catch it: `$(` is just text.
- **Drift: two paths** (missed in quiz 3, Q4): `terraform apply` = revert reality to the code; `terraform plan/apply -refresh-only` = accept reality into the state, infra untouched. `terraform refresh` is deprecated; `-refresh=false` skips the refresh (the opposite).
- **`init` is not needed before every apply** (session 3): only after adding/changing a provider, a module or the backend.
- **Variables in, outputs out** (missed in quiz 2, Q4): `variable` = input (parameter), `output` = return value (shown after apply, read by a parent as `module.<name>.<output>`), `locals` = internal, `data` = read from outside.
- **Plan display order ≠ execution order** (session 2): the plan lists resources alphabetically; execution follows the dependency graph (`random_pet` was created before `local_file`).
- **`-var` is not remembered** (session 2): each run without `-var` falls back to tfvars / default.
- **Variable precedence**, lowest → highest: `TF_VAR_` env vars < `terraform.tfvars` < `terraform.tfvars.json` < `*.auto.tfvars` (lexical order) < `-var` / `-var-file` on the CLI (last one wins).
- **State holds secrets in plain text**, even attributes marked sensitive → never commit it, use a remote backend with encryption and access control. **Missed in quiz 1 (Q4).** `sensitive = true` only hides the value in CLI output (plan/apply), not in the state file.

## Sub-objectives checklist

### 1. Infrastructure as Code (IaC) with Terraform
- [ ] 1a Explain what IaC is
- [ ] 1b Describe the advantages of IaC patterns
- [ ] 1c Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows

### 2. Terraform fundamentals
- [x] 2a Install and version Terraform providers
- [x] 2b Describe how Terraform uses providers
- [x] 2c Write Terraform configuration using multiple providers
- [x] 2d Explain how Terraform uses and manages state

### 3. Core Terraform workflow
- [x] 3a Describe the Terraform workflow
- [x] 3b Initialize a Terraform working directory
- [x] 3c Validate a Terraform configuration
- [x] 3d Generate and review an execution plan for Terraform
- [x] 3e Apply changes to infrastructure with Terraform
- [x] 3f Destroy Terraform-managed infrastructure
- [x] 3g Apply formatting and style adjustments to a configuration

### 4. Terraform configuration
- [x] 4a Use and differentiate resource and data blocks
- [x] 4b Refer to resource attributes and create cross-resource references
- [x] 4c Use variables and outputs
- [x] 4d Understand and use complex types
- [x] 4e Write dynamic configuration using expressions and functions
- [x] 4f Define resource dependencies in configuration (`depends_on`, `create_before_destroy`) — *new in 004*
- [x] 4g Validate configuration using custom conditions — *new in 004*
- [x] 4h Best practices for sensitive data, incl. secrets management with Vault (ephemeral values, write-only arguments) — *new in 004*

### 5. Terraform modules
- [x] 5a Explain how Terraform sources modules
- [x] 5b Describe variable scope within modules
- [x] 5c Use modules in configuration
- [ ] 5d Manage module versions

### 6. Terraform state management
- [x] 6a Describe the local backend
- [ ] 6b Describe state locking
- [ ] 6c Configure remote state using the backend block
- [x] 6d Manage resource drift and Terraform state (refresh-only, `moved`, `removed`)

### 7. Maintain infrastructure with Terraform
- [ ] 7a Import existing infrastructure into your Terraform workspace
- [x] 7b Use the CLI to inspect state
- [ ] 7c Describe when and how to use verbose logging

### 8. HCP Terraform
- [ ] 8a Use HCP Terraform to create infrastructure
- [ ] 8b Describe HCP Terraform collaboration and governance features
- [ ] 8c Describe how to organize and use HCP Terraform workspaces and projects — *new in 004*
- [ ] 8d Configure and use HCP Terraform integration

Source: [Exam Content List – Terraform Associate 004](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)
