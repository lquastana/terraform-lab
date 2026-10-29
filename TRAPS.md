# My Terraform exam traps

The 10 traps I keep falling into, with the target answer. Reread before each drill and before the exam.

---

## 1. `count` vs `for_each`: what happens when I remove an item?

**Picture it:** `count` = **numbered seats** in a row. `for_each` = **name badges**.

- **`count`** identifies instances by **position** (`[0]`, `[1]`, `[2]`).
  When an item leaves, **everyone behind it moves up one seat**:
  - instances **before** the removed one → untouched;
  - instances **after** it → **replaced** (their content shifts);
  - the **last** index → **destroyed**.

  | `["a","b","c"]` → remove… | Result |
  |---|---|
  | `"a"` (first) | `[0]` replaced, `[1]` replaced, `[2]` destroyed |
  | `"b"` (middle) | `[0]` untouched, `[1]` replaced, `[2]` destroyed |
  | `"c"` (last) | only `[2]` destroyed |

- **`for_each`** identifies instances by **key** (`["fhir"]`, `["postgres"]`).
  Remove `"a"` → **only `["a"]` is destroyed**. Nothing else moves. That is *why* `for_each` exists.

> **Rule:** if items can be added or removed, use `for_each`.

---

## 2. Variable precedence: from lowest to highest

**Rule:** *from the most distant to the closest to what I type now.*

1. `default` in the `variable` block — lowest
2. Environment variables `TF_VAR_<name>`
3. `terraform.tfvars`
4. `terraform.tfvars.json`
5. `*.auto.tfvars` / `*.auto.tfvars.json` — in **alphabetical** order
6. `-var` and `-var-file` on the command line — **highest** (if several, the **last one wins**)

> ⚠️ **Visual trap:** `TF_VAR_region=eu terraform plan` *looks* like part of the command, but it is still an **environment variable** → position 2, almost the lowest. Only `-var` / `-var-file` are real command-line arguments.
>
> Variables are set in **`.tfvars`** files — not in "state" files.

---

## 3. `terraform init -migrate-state` vs `-reconfigure`

Both are used with **`terraform init`** after **changing the `backend` block**. Without one of them, `init` stops and asks you to choose.

| | `-migrate-state` | `-reconfigure` |
|---|---|---|
| What it does | **Copies** the existing state from the old backend to the new one (asks for confirmation) | **Forgets** the old backend and starts on the new one **without copying anything** |
| Picture | Moving house **with your furniture** | Moving into an **empty apartment** |
| When | You change *where* the state is stored and want to **keep** tracking your infrastructure | You **deliberately** point to another state (e.g. another environment with partial config) |
| Risk | None — check that `plan` says "No changes" afterwards | If the new backend is empty, the next `plan` wants to **create everything** |

> Also remember: the **`backend` block cannot use variables** (it is initialised before variables are read) → use **partial configuration**: `terraform init -backend-config="key=value"` or `-backend-config=prod.hcl`.

---

## 4. `sensitive` vs `ephemeral` vs write-only

| | Shown in CLI output? | Stored in plan / state? |
|---|---|---|
| `sensitive = true` | **Hidden** (`(sensitive value)`, `<sensitive>`) | **Yes, in plain text** — also visible with `terraform output -raw` / `-json` |
| `ephemeral` (variables, outputs, `ephemeral` resources) | — | **Never.** Exists only during the run ("Opening… / Closing…") |
| **Write-only argument** (`*_wo`, e.g. `password_wo`) | — | **Never.** Sent to the API at apply time, then forgotten |

- A **write-only argument** is a resource argument defined by the **provider**. It is the **only kind of resource argument that accepts an ephemeral value** (`content` refused mine: *"not a write-only attribute and must be persisted to state"*).
- Terraform cannot compare a value it doesn't keep → write-only arguments come with a **`*_wo_version`** argument: **increment it** to push a new value.
- An **output** that uses a sensitive value must be marked `sensitive = true`, otherwise: *"Output refers to sensitive values"*.

> **One sentence:** *sensitive **hides**, ephemeral **doesn't store**, write-only is **where a resource can receive ephemeral values**.*
> Protect the state anyway: remote backend, encryption, access control.

---

## 5. Custom conditions: which ones block the run?

| Tool | Where | When | If it fails |
|---|---|---|---|
| `validation` | inside a `variable` block | when the value is read | **Error** — run stops |
| `precondition` | `lifecycle` of a resource / data source / output | **before** the object | **Error** — run stops |
| `postcondition` | `lifecycle` of a resource / data source | **after** the object (uses `self`) | **Error** — run stops |
| `check` block | top level | end of plan / apply | **Warning only** — run continues |

> And Terraform **never rolls back**: if an apply fails halfway, what was created stays in the state.

---

## 6. Module sources and `version`

| Source | Example | How to pin |
|---|---|---|
| Local path | `./modules/service-file` (must start with `./` or `../`) | No version — it's my own code |
| Public registry | `terraform-aws-modules/vpc/aws` → `<NAMESPACE>/<NAME>/<PROVIDER>` | **`version = "~> 5.0"`** |
| Private registry | `app.terraform.io/<ORG>/<NAME>/<PROVIDER>` | **`version = "~> 1.0"`** |
| Git | `git::https://github.com/org/repo.git//subdir?ref=v1.2.0` | **`?ref=`** in the URL (tag, branch or commit) |
| HTTP archive | `https://example.com/module.zip` | Not versionable |

> **Rule:** `version` → **registry only** (public or private). Adding `version` to a local path or Git source → error.
> `//subdir` = folder inside the repo. Changing a module's `source` or `ref` → run **`terraform init`** again ("Module source has changed").

---

## 7. `TF_LOG` levels, and `TF_LOG_PATH`

**Most → least verbose: `TRACE` → `DEBUG` → `INFO` → `WARN` → `ERROR`**
Mnemonic: ***"To Debug, Inspect Warnings and Errors."***

- **`TF_LOG`** = the **switch and the volume**: turns logging on and picks the level. Without it → no logs at all.
- **`TF_LOG_PATH`** = only the **delivery address** (a file).
  - `TF_LOG` alone → logs on **stderr** (the terminal).
  - `TF_LOG` + `TF_LOG_PATH` → logs written to the file.
  - **`TF_LOG_PATH` alone → nothing is written.**
- `TF_LOG=JSON` is a **format** (TRACE level, JSON output), not a level.
- `TF_LOG_CORE` / `TF_LOG_PROVIDER` → separate logs for Terraform core and providers.
- A Terraform crash writes **`crash.log`**. Logs can contain secrets → clean them before sharing.

---

## 8. CLI workspaces vs HCP Terraform workspaces

- **CLI workspace** = **several state files for the same code**, in the same working directory.
  Same code, same variables, same backend — only the state changes (`terraform.tfstate.d/<name>/` with the local backend; they also exist with remote backends).
  `terraform workspace new | select | list | delete` · `${terraform.workspace}` gives the current name · **`default` can never be deleted** · a workspace with resources can't be deleted (except `-force`, which orphans them).
- **HCP Terraform workspace** = a **complete object**: its own code source (CLI or VCS repo), **its state**, **its variables** (Terraform + environment, sensitive ones are write-only), **its permissions**, **its run history**, its settings (execution mode Remote / Local / Agent, Terraform version).
  Organisation → **projects** → workspaces.

> If a question says "own variables / permissions / run history" → **HCP** workspace.

---

## 9. `terraform refresh` vs `-refresh-only`

Both update the **state** to match **reality**, **without changing the infrastructure**. The difference is **control**:

- **`terraform refresh`** — **deprecated**: writes the state **immediately, without showing anything**.
- **`terraform plan -refresh-only`** → shows *"Objects have changed outside of Terraform"* → then **`terraform apply -refresh-only`** writes it after `yes`.

**Drift — two paths:**
- The code is right → plain **`terraform apply`** puts reality back to the code.
- The manual change is right → `plan -refresh-only` → `apply -refresh-only` → **update the code** → `plan` says "No changes".

> Don't confuse with `-refresh=false`, which **skips** the refresh (the opposite).

---

## 10. The dependency lock file `.terraform.lock.hcl`

- ✅ Pins the **exact version of each provider** + its **checksums** (hashes).
- ❌ Does **not** pin **module** versions → use `version` or `?ref=`.
- ❌ Does **not** pin the **Terraform core** version → use `required_version`.
- **Commit it** to Git. Created/updated by `terraform init`; `terraform init -upgrade` moves to the newest versions allowed by the constraints.

---

## Bonus: quick traps

- **`~>` lets only the rightmost number move:** `~> 2.5` = `>= 2.5, < 3.0` · `~> 2.5.0` = `>= 2.5.0, < 2.6.0` · `>= 2.5` has **no upper limit**.
- **Variables in, outputs out.** The parent sees a module **only through its outputs**: `module.<call>.<output>`. A child never inherits the parent's variables; a child variable without default is **required**.
- **Interpolation** is `${ }`, only inside quotes. Never `$( )` (that's bash). A bare expression needs no quotes.
- **The plan lists resources alphabetically**; execution follows the **dependency graph**.
- **Run `terraform init` again** after adding/changing a provider, a module, or the backend — not before every apply.
- **Remote execution (HCP):** plan/apply run on a temporary worker; a `local_file` ends up on the worker, not on my machine. The state lives in HCP.
- **Import:** `import` block → shown in the plan, `plan -generate-config-out=<new file>` writes the code. `terraform import` CLI → resource block required first, writes the state immediately, no plan.
