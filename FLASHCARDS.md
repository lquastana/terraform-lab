# Flashcards — repeat offenders only

Built after mock exam 3 (37/50, plateau ~73 %). These are **only** the things I have already got
wrong at least once in a drill or a mock. Nothing here is new material.

**How to use:** 5 minutes, every session and the morning of the exam. Read the question, say the
answer **out loud**, then open it. A card I miss goes back to the top of the pile.
Exam method: answer with the **letter + 2–3 words of justification**, then reread every question once.

**The 6 that cost me the most** → cards 1, 2, 3, 6, 8, 9.

---

### 1. In `dynamic "ingress"`, how do I reference the current element? · missed 4× (quiz 12, drill 7 Q4, mock 2 Q26, mock 3 Q18)

<details><summary>Answer</summary>

**`ingress.key` / `ingress.value`** — the iterator takes **the name of the block**.

- Rename it with `iterator = rule` → then it is `rule.key` / `rule.value`.
- **Never `each`** → that is `for_each` on a **resource** or a **module**.
- **Never `self`** → that is `postcondition` (and provisioners), an object referring to itself.

```hcl
dynamic "ingress" {
  for_each = var.ports
  content {
    from_port = ingress.value      # ingress = the block's name
    to_port   = ingress.value
  }
}
```
</details>

### 2. What exactly does `.terraform.lock.hcl` pin? · missed 2× (drill 4 Q8, mock 3 Q6)

<details><summary>Answer</summary>

**Provider versions + their checksums (hashes).** That is all. Commit it.

- ❌ **not** module versions → `version` (registry) or `?ref=` (Git)
- ❌ **not** the Terraform core version → `required_version`
- Created and updated by `init`; `init -upgrade` moves to the newest versions the constraints allow.
</details>

### 3. Which module sources accept `version`? · missed 3× (quiz 6 Q4, drill 1 Q7, mock 3 Q28 + Q29)

<details><summary>Answer</summary>

**Registry only — public *and* private.** Anywhere else, `version` is an error.

| Source | Format | Pin |
|---|---|---|
| Local | `./modules/x` (must start with `./` or `../`) | nothing — it is my code |
| Public registry | `<NAMESPACE>/<NAME>/<PROVIDER>` → `terraform-aws-modules/vpc/aws` | `version = "~> 5.0"` |
| **Private registry** | **`<HOST>/<ORG>/<NAME>/<PROVIDER>`** → `app.terraform.io/acme/app/azurerm` | `version = "~> 1.0"` |
| Git | `git::https://…/repo.git//subdir?ref=v1.2.0` | `?ref=` in the URL |
| HTTP archive | `https://…/module.zip` | not versionable |

**The private-registry tell: the host comes first** (4 segments instead of 3).
Changing `source` or `ref` → run `terraform init` again ("Module source has changed").
</details>

### 4. `~> 2.5` — what does it allow? · missed 1× (session 1: wrote `>= 2.5`)

<details><summary>Answer</summary>

**Only the rightmost written number may move.**

- `~> 2.5` = `>= 2.5, < 3.0` (minor can move)
- `~> 2.5.0` = `>= 2.5.0, < 2.6.0` (patch only)
- `>= 2.5` = **no upper limit at all**
</details>

### 5. Variable precedence, lowest → highest? · missed 2× (drill 1 Q6, drill 2 Q2)

<details><summary>Answer</summary>

*From the most distant to the closest to what I type right now:*

1. `default` in the `variable` block
2. `TF_VAR_<name>` environment variables
3. `terraform.tfvars`
4. `terraform.tfvars.json`
5. `*.auto.tfvars` / `.json` — in **alphabetical** order
6. `-var` / `-var-file` on the CLI — **wins**; if several, the **last one**

⚠️ **Visual trap:** `TF_VAR_region=eu terraform plan` *looks* like the command line, but it is an
**environment variable** → position 2, nearly the lowest. Only `-var` / `-var-file` are real CLI arguments.
</details>

### 6. Run **tasks** vs run **triggers**? · missed 2× (drill 6 Q6, drill 7 Q5)

<details><summary>Answer</summary>

- **Run task** = plug an **external tool** into a run (security scan, cost estimate). *A task handed to another tool.*
- **Run trigger** = queue a run in **another workspace** when this one applies. *A trigger between workspaces.*

Same family, do not mix up:
- **Policies** (Sentinel / OPA) run **after the plan, before the apply**. Enforcement levels:
  **advisory** (warns) · **soft-mandatory** (can be overridden by authorised users) · **hard-mandatory** (must pass).
  "Mandatory-override" does not exist.
- A **policy set** = a group of policies (not a project).
</details>

### 7. Rights over a whole set of workspaces at once? · missed 2× (drill 6 Q7, mock 3 Q48)

<details><summary>Answer</summary>

**A project.** Organisation → **projects** → workspaces; the project carries the permissions.

**Teams = groups of *people*.** A team is granted rights **on** a project. If the question says
"group workspaces" it is a project; if it says "group users" it is a team.
</details>

### 8. `count` — I remove one item from the list. What happens? · missed 4× (quiz 4 Q3, drills 1, 2, 3)

<details><summary>Answer</summary>

**Numbered seats: when someone leaves, only the people *behind* them move up.**

| `["a","b","c"]`, remove… | Result |
|---|---|
| `"a"` (first) | `[0]` replaced, `[1]` replaced, `[2]` destroyed |
| `"b"` (middle) | `[0]` untouched, `[1]` replaced, `[2]` destroyed |
| `"c"` (last) | **only `[2]` destroyed** |

`for_each` = **name badges**: remove `"a"` → **only `["a"]` is destroyed**, nothing else moves.
→ If items can come and go, use `for_each`. And `count` + `for_each` on the same resource =
**"Invalid combination"**, never allowed.
</details>

### 9. VCS-connected HCP workspace, and I run `terraform apply` from my terminal? · missed 2× (session 10 proof, mock 3 Q45)

<details><summary>Answer</summary>

**Error — refused.** A VCS-driven workspace only takes runs from Git (push to the tracked branch;
a PR gives a **speculative plan** as a check).

- **CLI-driven** = `cloud` block, runs launched from the terminal.
- **Speculative plan** = cannot be applied, runs automatically on PRs, never touches the state.
- Execution mode **Local** = plan/apply on my machine, **state still in HCP**. "Speculative" is not
  an execution mode (the modes are Remote / Local / Agent).
</details>

### 10. What does the state file actually contain? · missed 3× (mock 2 Q9, drill 6 Q14, drill 6b Q6)

<details><summary>Answer</summary>

Top-level keys, proved on a real `terraform.tfstate`: `version`, `terraform_version`, `serial`,
`lineage`, `outputs`, `resources`, `check_results`.

**No `variables` key** — `variable` blocks live in the code; their values only appear where they are
*used* (resource attributes, outputs), **in plain text even when marked `sensitive`**.
Also not in the state: the provider **binaries** (those are in `.terraform/`).

**The 4 roles:** **mapping** (address → real id) · **metadata** (`dependencies`) ·
**performance** (cache — `plan -refresh=false` trusts it and misses drift) ·
**syncing** (`serial` +1 on every write, `lineage` = identity, locking).
</details>

### 11. `init -migrate-state` vs `init -reconfigure`? · missed 2× (drill 3 Q6, mock 3 Q39)

<details><summary>Answer</summary>

Both go with `terraform init` after changing the **`backend` block**.

- **`-migrate-state`** = moving house **with the furniture**: copies the state across → afterwards
  `plan` says "No changes".
- **`-reconfigure`** = moving into an **empty flat**: forgets the old backend, copies **nothing** →
  if the new backend is empty, the next plan wants to **create everything**.

The `backend` block **cannot use variables** → partial configuration:
`init -backend-config="key=value"` or `-backend-config=prod.hcl`.
</details>

### 12. `sensitive` vs `ephemeral` vs write-only? · missed 3× (quiz 1 Q4, mock 2 Q24, mock 3 Q25)

<details><summary>Answer</summary>

**`sensitive` hides · `ephemeral` never stores · write-only is *where* a resource can receive an ephemeral value.**

| | CLI output | Plan / state |
|---|---|---|
| `sensitive = true` | hidden, `(sensitive value)` | **plain text** — and `output -raw` / `-json` print it |
| `ephemeral` | — | **never** ("Opening… / Closing…" on each run) |
| write-only argument (`password_wo`) | — | **never**: sent to the API at apply, then forgotten |

- An ephemeral value is accepted in **exactly two places: a `provider` block and a write-only
  argument** (that was the "choose two" of mock 3 Q25).
- Write-only comes with **`*_wo_version`** — increment it to push a new value.
- A root `output` built from a sensitive value **must** be `sensitive = true`, otherwise it errors.
</details>

### 13. Which custom conditions stop the run? · missed 1× (quiz 5 Q3)

<details><summary>Answer</summary>

**`validation`, `precondition`, `postcondition` → error, the run stops.**
**`check` block → warning only, the run continues.**

`postcondition` is the one that uses **`self`**. And Terraform **never rolls back**: whatever an
interrupted apply already created stays in the state.
</details>

### 14. `TF_LOG` and `TF_LOG_PATH`? · missed 2× (session 7 pre-quiz, mock 3 Q43)

<details><summary>Answer</summary>

**`TF_LOG` = the switch and the volume. `TF_LOG_PATH` = the delivery address only.**

- `TF_LOG` alone → logs on **stderr**, in the terminal. That is not an error.
- **`TF_LOG_PATH` alone → nothing is written at all.**
- Levels, most → least verbose: **TRACE > DEBUG > INFO > WARN > ERROR** —
  *"To Debug, Inspect Warnings and Errors."*
- `TF_LOG=JSON` is a **format** (TRACE, in JSON), not a level. `TF_LOG_CORE` / `TF_LOG_PROVIDER` split them.
- A crash writes **`crash.log`**. Logs can contain secrets — clean them before sharing.
</details>

### 15. Accept a manual change into the state without touching the infrastructure? · missed 1× (quiz 3 Q4)

<details><summary>Answer</summary>

**`terraform plan -refresh-only`** then **`terraform apply -refresh-only`** (shows "Objects have
changed outside of Terraform", writes after `yes`), **then update the code** → `plan` says "No changes".

- `terraform refresh` does the same but is **deprecated** and silent.
- `-refresh=false` **skips** the refresh — the opposite.
- If the code is the one that is right: plain `terraform apply` puts reality back to the code.
</details>

### 16. "Which command does X?" — the five that got me · missed 5/5 of that block on mock 1

<details><summary>Answer</summary>

| I want to… | Command |
|---|---|
| Preview **and save** the plan | `terraform plan -out=tfplan` → `apply tfplan` (no prompt; replaying it after the state moved = **"Saved plan is stale"**) |
| Check formatting in **CI** | `terraform fmt -check` (**non-zero exit code**, lists the files, rewrites nothing; `-recursive` for subfolders) |
| **Read** an object I do not manage | a **`data`** block → referenced as **`data.<type>.<name>.<attr>`**; without the `data.` prefix it is a managed resource |
| **Generate the code** after `import` blocks | `terraform plan -generate-config-out=generated.tf` |
| **List** the resources in the state | `terraform state list` |
| Release a **stuck lock** | `terraform force-unlock LOCK_ID` (`init -unlock` does not exist; `-lock=false` only skips locking) |

On these questions the wrong answers are **real commands that do something else**. Read every option to the end.
</details>

### 17. Import: the two ways · missed 2× (mock 2 Q40, drill 6 Q9)

<details><summary>Answer</summary>

- **`import` block** → arguments **`to`** (the address in my code) and **`id`** (the real object's id).
  Shown in the **plan**, several at once, works in CI/HCP, and `plan -generate-config-out=<new file>`
  writes the resource block for me (it never overwrites an existing file).
- **`terraform import <address> <id>`** (CLI) → the **resource block must exist first**, writes the
  state immediately, no plan, one at a time, generates no code.

After any import: `plan` **must** say "No changes".
</details>

### 18. Mock 3's one-liners · new misses, 2026-11-15

<details><summary>Answer</summary>

- **Idempotency** = the same configuration applied twice → the second run says **"No changes"**.
- Several `provider` blocks → a resource uses the one **without `alias`** by default; otherwise
  **`provider = aws.west`** (name `.` alias, no quotes).
- **`terraform apply` never upgrades providers** — only **`init -upgrade`** does.
- Number of elements = **`length()`**. There is no `size()`.
- Provider tiers: **Official = HashiCorp** · Partner = companies · Community = individuals.
- A parent sees a module **only through its outputs** (`module.<call>.<output>`); a child variable
  with no `default` is **required**.
- Run `init` again only after adding or changing a **provider, a module or the backend** —
  not before every apply.
</details>

---

*Every card comes from a real miss logged in `PROGRESS.md` / `TRAPS.md`. Maintenance: after each
drill, a card answered right three sessions in a row leaves the pile, and any new repeat offender joins it.*
