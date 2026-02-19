# general instructions for some programming languages

Only use if there is no project specific agents.md

## rust projects

After every code change, run these command & fix the errors before presenting
the result:

```bash
cargo fmt
cargo check
cargo clippy
```

## pre-commit

If there is a `.pre-commit-config.yaml` file, you can run pre-commit after every
code change, commit on the changed files before presenting the result:

```bash
pre-commit run --files <changed files>
```
