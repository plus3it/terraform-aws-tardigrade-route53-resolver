# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates an AWS Route 53 Resolver endpoint and, optionally, query log configurations and resolver rules that use it. The main inputs are `direction`, `security_group_ids`, and `ip_addresses` for the endpoint, plus the optional `query_log_configs` and `rules` lists, each of which can carry VPC associations. The module outputs `resolver_endpoint`, `query_log_configs`, and `rules`.

### Module-specific files

- `modules/query-log-config/` — Creates a resolver query log config and its VPC associations; the root module calls it once for each item in `query_log_configs`
- `modules/query-log-config-association/` — Creates one query log config association; `modules/query-log-config/` calls it, and consumers call it directly for cross-account associations (as `tests/cross-account-associations/` does)
- `modules/rule/` — Creates a resolver rule and its VPC associations; the root module calls it once for each item in `rules`, passing the endpoint ID only for `FORWARD` rules
- `modules/rule-association/` — Creates one resolver rule association; `modules/rule/` calls it, and consumers call it directly for cross-account associations (as `tests/cross-account-associations/` does)
