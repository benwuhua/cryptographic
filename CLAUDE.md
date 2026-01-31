# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a HarmonyOS application (bundle: `com.ryan.mi`) built with the ArkTS/ETS framework, targeting HarmonyOS SDK 6.0.2. It uses the Stage model application architecture.

## Build System

The project uses **Hvigor** (HarmonyOS build tool). Builds are typically run through DevEco Studio IDE, but can also use command line:

```bash
# Build the project
hvigorw assembleHap

# Build with specific product/mode
hvigorw assembleHap -p product=default -p buildMode=debug
hvigorw assembleHap -p product=default -p buildMode=release

# Clean build artifacts
hvigorw clean
```

## Testing

Tests use the **Hypium** framework (`@ohos/hypium`):

- **Local unit tests**: `entry/src/test/` - Run without device
- **Instrumented tests (ohosTest)**: `entry/src/ohosTest/` - Require device/emulator

Tests follow the pattern:
```typescript
import { describe, it, expect } from '@ohos/hypium';
describe('suiteName', () => {
  it('testName', 0, () => {
    expect(actual).assertEqual(expected);
  });
});
```

## Linting

Code linting is configured in `code-linter.json5` with strict security rules enabled for cryptographic operations:
- No unsafe AES, hash, MAC, DH, DSA, ECDSA, RSA, or 3DES usage
- Performance and TypeScript recommended rules

## Architecture

```
entry/                          # Main application module
├── src/main/
│   ├── ets/
│   │   ├── entryability/      # UIAbility lifecycle (app entry point)
│   │   ├── entrybackupability/# BackupExtensionAbility
│   │   └── pages/             # UI pages (ArkTS components)
│   ├── resources/             # String, color, media resources
│   └── module.json5           # Module configuration
├── src/test/                  # Local unit tests
├── src/ohosTest/              # Instrumented tests
└── src/mock/                  # Mock configurations

AppScope/                      # Application-wide config (app.json5)
```

### Key Concepts

- **UIAbility**: Application lifecycle manager (`EntryAbility.ets`) - handles creation, foreground/background transitions, window management
- **Pages**: Declarative ArkTS UI components using `@Component` and `@Entry` decorators
- **Resources**: Accessed via `$r('app.type.name')` syntax (e.g., `$r('app.float.page_text_font_size')`)
- **Page routing**: Defined in `resources/base/profile/main_pages.json`

## ArkTS/ETS Specifics

- Files use `.ets` extension (extended TypeScript for UI)
- UI built with declarative syntax: components return builder methods, not JSX
- State management: `@State`, `@Prop`, `@Link` decorators
- Lifecycle hooks: `onCreate`, `onDestroy`, `onForeground`, `onBackground`
