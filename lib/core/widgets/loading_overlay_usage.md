# Loading Overlay Usage Guide

## Available Loading Widgets

### 1. `FullScreenLoader`

Use for full-screen loading states when initial data is being loaded.

```dart
if (isLoading && data.isEmpty) {
  return FullScreenLoader(message: l10n.loading);
}
```

### 2. `LoadingOverlay`

Use to overlay loading on top of existing content.

```dart
LoadingOverlay(
  isLoading: isLoading,
  message: 'Loading...',
  child: YourContentWidget(),
)
```

### 3. `InlineLoader`

Use for inline loading indicators (e.g., in lists, pagination).

```dart
if (isLoadingMore) {
  return const Center(child: InlineLoader());
}
```

### 4. `ButtonLoader`

Use inside buttons when an action is in progress.

```dart
ElevatedButton(
  onPressed: isLoading ? null : handleAction,
  child: isLoading
    ? const ButtonLoader()
    : Text('Submit'),
)
```

## Best Practices

1. **Full Screen**: Use `FullScreenLoader` when loading initial data
2. **Overlay**: Use `LoadingOverlay` when you want to show content with loading
3. **Inline**: Use `InlineLoader` for pagination or partial loading
4. **Button**: Use `ButtonLoader` for button loading states

## Examples

### Example 1: Full Screen Loading

```dart
if (state.isLoading && state.posts.isEmpty) {
  return FullScreenLoader(message: l10n.loading);
}
```

### Example 2: Loading Overlay

```dart
LoadingOverlay(
  isLoading: isLoading,
  child: ListView(...),
)
```

### Example 3: Button Loading

```dart
ElevatedButton(
  onPressed: isLoading ? null : submit,
  child: isLoading ? const ButtonLoader() : Text('Submit'),
)
```

### Example 4: Inline Loading (Pagination)

```dart
if (index == items.length) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Center(child: InlineLoader()),
  );
}
```
