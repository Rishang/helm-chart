# Docs UI (Docusaurus)

This directory contains the Docusaurus UI for this repository’s Helm chart docs.

## Local dev

From `web/`:

```bash
pnpm install
pnpm start
```

## Docs sources

- `component-chart` docs are sourced directly from `../charts/component-chart/docs/pages` and are served at `/component-chart`.
- More chart doc sets (e.g. `loki-stack`) can be added later as additional Docusaurus docs plugin instances in `docusaurus.config.js`.


