# StepSecurity PoC — End-to-End Example

A small, end-to-end Terraform example intended for a Proof of Concept. It wires up four StepSecurity resources against a customer org, scoped to a short list of repos:

| Resource | Purpose |
|---|---|
| `stepsecurity_github_checks` | Required PR checks (NPM/PyPI cooldown + compromised updates) on the PoC repos. |
| `stepsecurity_github_pr_template` | Org-level PR title / body / commit message used by policy-driven PRs. |
| `stepsecurity_policy_driven_pr` | Auto-remediation PRs (harden runner, pin actions, restrict `GITHUB_TOKEN`) on the PoC repos. |
| `stepsecurity_github_policy_store` + `_attachment` | A block-mode egress policy (only the listed endpoints are reachable), attached at the **repo level** to each PoC repo. |

## Variables

| Variable | Type | Example |
|---|---|---|
| `poc_org` | `string` | `"acme-poc"` |
| `poc_repos` | `list(string)` | `["repo-a", "repo-b"]` |

These are passed in by the GitHub Actions workflow ([`.github/workflows/poc-apply.yml`](../../.github/workflows/poc-apply.yml)) from `workflow_dispatch` inputs.

## Running it

The PoC is designed to be driven from the **PoC: Apply StepSecurity config** workflow in this repo:

1. Set the following repo secrets:
   - `STEP_SECURITY_API_KEY`
   - `STEP_SECURITY_CUSTOMER`
2. From the **Actions** tab, run **PoC: Apply StepSecurity config**.
3. Fill in the inputs:
   - `poc_org` — the GitHub org name
   - `poc_repos` — comma-separated repos (e.g. `repo-a,repo-b`)
   - `action` — `plan` to dry-run, `apply` to make changes
4. Re-run with `action = apply` once the plan looks correct.

## State

This example uses **local state**, which means the workflow's ephemeral runner won't remember prior runs — every dispatch starts fresh. That's fine for a one-shot PoC apply, but for ongoing management switch to remote state (S3, Terraform Cloud, etc.) and re-import the existing resources using the import IDs documented for each resource in the [provider docs](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs).
