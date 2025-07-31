# Unified Configuration

This directory contains shared configuration files to reduce code duplication across the emote-generator projects using proper TypeScript inheritance patterns.

## Structure

- `eslint.config.js` - Shared ESLint configuration for both projects
- `tsconfig.base.json` - Base TypeScript configuration with common settings
- `tsconfig.node.json` - Node.js/Express specific TypeScript configuration
- `tsconfig.vue.json` - Vue-specific TypeScript configuration

## Configuration Hierarchy

### TypeScript Configuration Inheritance

```
tsconfig.base.json (common settings)
├── tsconfig.node.json (Node.js specific)
│   └── tsconfig.json (main project)
└── tsconfig.vue.json (Vue specific)
    └── generator/tsconfig.json (generator project)
```

### Inheritance Benefits

1. **Base Configuration**: Common settings like `target`, `module`, `strict` flags, and path mappings are defined once
2. **Environment-Specific**: Node.js and Vue projects have their own specific settings (e.g., `moduleResolution`, `lib`, `jsx`)
3. **Project-Specific**: Each project can override or extend settings as needed
4. **Maintainability**: Changes to common settings only need to be made in one place

### Important Configuration Notes

**Path Resolution**: When TypeScript extends a config file, paths in the extended config are resolved relative to the extended config's location, not the project root. This means:
- `rootDir` and `outDir` should be defined in the project-level `tsconfig.json` files
- Shared configs should avoid these path-dependent settings
- Path mappings in shared configs use relative paths from the shared config location

## Path Aliases

Both projects now support convenient path aliases for cleaner imports:

### Main Project (Node.js API)
- `@/*` → `src/*`
- `@types/*` → `src/types/*`
- `@/util` → `src/util`
- `@/settings` → `src/settings`

### Generator Project (Vue Frontend)
- `@/*` → `src/*`
- `@types/*` → `types/*`
- `@/components/*` → `src/components/*`
- `@/stores/*` → `src/stores/*`
- `@/composables/*` → `src/composables/*`
- `@/util` → `src/util`
- `@/settings` → `src/settings`

### Usage Examples

**Before (relative imports):**
```typescript
import type { Blueprint } from "./types/main"
import { blueprintPath } from "./settings"
import { someUtil } from "./util"
```

**After (path aliases):**
```typescript
import type { Blueprint } from "@types/main"
import { blueprintPath } from "@/settings"
import { someUtil } from "@/util"
```

**Vue Components:**
```typescript
// Before
import { useStore } from "../stores/emoteStore"
import EmoteLayout from "./components/EmoteLayout.vue"

// After
import { useStore } from "@/stores/emoteStore"
import EmoteLayout from "@/components/EmoteLayout.vue"
```

## Setup Requirements

### Main Project
- TypeScript path mappings are configured in `tsconfig.json`
- `rootDir` and `outDir` are defined in the project-level config
- No additional build tool configuration needed

### Generator Project
- TypeScript path mappings are configured in `generator/tsconfig.json`
- Vite path aliases are configured in `generator/vite.config.ts`
- Both configurations must match for proper resolution

## Benefits

1. **Cleaner Imports**: No more long relative paths like `../../../components/SomeComponent`
2. **Easier Refactoring**: Moving files doesn't break import paths
3. **Better IDE Support**: Autocomplete and navigation work better with absolute paths
4. **Consistency**: Standardized import patterns across the project
5. **Maintainability**: Centralized path configuration
