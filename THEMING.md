# LinaTeX Theming System

## Overview

LinaTeX uses a modern, light-by-default theming system inspired by Tailwind CSS. Support for dark mode is available through `AppViewModel.isDarkMode`.

## Current Theme Implementation

### ModernTheme
Defined in `Models/ModernTheme.swift`, provides:
- **Background Colors**: bgPrimary, bgCard, bgSubtle, bgElevated
- **Text Colors**: textPrimary, textSecondary, textTertiary, textMuted
- **Accent Colors**: primary, secondary, accent (with light and soft variants)
- **Status Colors**: success, warning, danger (with soft variants)
- **Borders & Shadows**: border, borderLight, borderStrong, shadowColor
- **Gradients**: backgroundGradient, primaryGradient, heroGradient, cardGradient
- **Code/Terminal**: codeBg, codeBgSoft, codeText

### ModernFont
Defined in `Models/ModernTheme.swift`, provides font scales:
- displayLarge, headlineLarge, headlineSmall
- bodyMedium, bodySmall, bodyEmphasized, bodyEmphasizedSmall
- labelLarge, labelMedium, labelSmall
- codeMedium, codeSmall, captionSmall

### Course Level Colors
Each difficulty level has associated colors:
- **Basics** (.basics): Soft aqua/teal
- **Standard** (.standard): Orange/amber
- **Advanced** (.advanced): Purple/violet

## Dark Mode Support

### Enabling Dark Mode
Currently, dark mode preference is controlled by `AppViewModel.isDarkMode`:

```swift
vm.isDarkMode = true  // Enable dark mode
vm.isDarkMode = false // Revert to light mode
```

The app applies this preference via:
```swift
.preferredColorScheme(vm.isDarkMode ? .dark : .light)
```

### Future Enhancement: System Dark Mode
To follow system dark mode preference, use:
```swift
@Environment(\.colorScheme) var colorScheme
```

## Theme Customization

To customize theme colors:
1. Edit `Models/ModernTheme.swift`
2. Update color hex values
3. Test in both light and dark modes

## Terminal Colors

Terminal components use hardcoded colors for authentic look:
- Background: `Color(hex: 0x1E293B)` (slate-800)
- Text: `Color(hex: 0x10B981)` (emerald-500) for prompt
- User input: white
- Cursor: emerald-500

## Design Philosophy

- **Light-first**: App is optimized for light mode by default
- **Accessibility**: All colors meet WCAG AA contrast ratios
- **Consistency**: Uses standardized color palette across all components
- **Flexibility**: Easy to extend for additional themes

## To-Do: Full Dark Mode Theme

Future work includes:
- [ ] Define dark mode color palette
- [ ] Update ModernTheme for `@Environment(\.colorScheme)`
- [ ] Test accessibility in dark mode
- [ ] Update all gradients for dark mode
- [ ] Consider dark mode-specific typography adjustments
