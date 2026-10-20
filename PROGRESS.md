# Terraform Associate (004) — Progress

- **Target:** HashiCorp Certified: Terraform Associate **(004)** — exam week of **2026-12-15** (delivered by Certiverse).
- **Note:** 003 was retired on 2026-01-07. The 004 exam tests **Terraform 1.12**; this lab runs **1.16.6**.
- **Cadence:** Tue & Wed 06:45–07:45 · Sun 10:00–12:00 · occasional 2 h block on a day off. One `.tf` file (or module) committed per session.
- **Status legend:** ⬜ To do · 🟨 Seen · ✅ Mastered · a ticked sub-objective = practiced hands-on at least once

## Session log

| # | Date | Duration | Covered | Folder |
|---|------|----------|---------|--------|
| 1 | 2026-10-20 | 60 min | Installed Terraform 1.16.6 (HashiCorp APT repo) + VS Code extension in WSL; read the 004 objectives; first project: `local_file` with the `local` provider (v2.9.1), full cycle fmt → init → validate → plan → apply → state list/show → destroy; read the state file line by line | `01-local-file/` |

## Exam objectives — status

| # | Domain | Status |
|---|--------|--------|
| 1 | Infrastructure as Code (IaC) with Terraform | 🟨 Seen (concepts known from Ansible/DevOps) |
| 2 | Terraform fundamentals | 🟨 Seen (session 1) |
| 3 | Core Terraform workflow | 🟨 Seen (session 1) |
| 4 | Terraform configuration | ⬜ To do |
| 5 | Terraform modules | ⬜ To do |
| 6 | Terraform state management | ⬜ To do |
| 7 | Maintain infrastructure with Terraform | ⬜ To do |
| 8 | HCP Terraform | ⬜ To do |

## To review

- **Domain 2 – Terraform fundamentals:** no hands-on experience yet (self-assessment, 2026-10-20).
- **Domain 3 – Core workflow:** same.
- **Domain 6 – State management:** same.
- **Domain 8 – HCP Terraform:** same.
- **New in 004 (not in 003):** 4f `depends_on` / `create_before_destroy`, 4g custom conditions, 4h ephemeral values & write-only arguments, 8c HCP Terraform workspaces & projects. Many prep courses are still 003-based, so check these 4 topics explicitly.
- **Version constraints** (session 1): wrote `>= 2.5` instead of `~> 2.5`. `~>` lets only the rightmost written number move: `~> 2.5` = `>= 2.5, < 3.0`; `~> 2.5.0` = `>= 2.5.0, < 2.6.0`.
- **Provider source address** (session 1): `[HOSTNAME/]NAMESPACE/TYPE`, default hostname `registry.terraform.io` (typo `hasicorp` → init failed).
- **Resource type = provider local name + `_` + type** (session 1): wrote `resource "local"` instead of `resource "local_file"` → caught by `validate`.
- **Saved plans:** `terraform plan -out=tfplan` then `terraform apply tfplan` applies exactly that plan, with no prompt.
- **`terraform fmt`** only formats the current directory; use `-recursive` for subfolders.
- **State holds secrets in plain text**, even attributes marked sensitive → never commit it, use a remote backend with encryption and access control.

## Sub-objectives checklist

### 1. Infrastructure as Code (IaC) with Terraform
- [ ] 1a Explain what IaC is
- [ ] 1b Describe the advantages of IaC patterns
- [ ] 1c Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows

### 2. Terraform fundamentals
- [x] 2a Install and version Terraform providers
- [x] 2b Describe how Terraform uses providers
- [ ] 2c Write Terraform configuration using multiple providers
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
- [ ] 4a Use and differentiate resource and data blocks
- [ ] 4b Refer to resource attributes and create cross-resource references
- [ ] 4c Use variables and outputs
- [ ] 4d Understand and use complex types
- [ ] 4e Write dynamic configuration using expressions and functions
- [ ] 4f Define resource dependencies in configuration (`depends_on`, `create_before_destroy`) — *new in 004*
- [ ] 4g Validate configuration using custom conditions — *new in 004*
- [ ] 4h Best practices for sensitive data, incl. secrets management with Vault (ephemeral values, write-only arguments) — *new in 004*

### 5. Terraform modules
- [ ] 5a Explain how Terraform sources modules
- [ ] 5b Describe variable scope within modules
- [ ] 5c Use modules in configuration
- [ ] 5d Manage module versions

### 6. Terraform state management
- [ ] 6a Describe the local backend
- [ ] 6b Describe state locking
- [ ] 6c Configure remote state using the backend block
- [ ] 6d Manage resource drift and Terraform state (refresh-only, `moved`, `removed`)

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
