# Animation System

This directory contains the animation system for the Seervi Kshatriya Samaj Vadodara app, designed with performance and accessibility in mind.

## Components

### 1. Animation Constants (`animation_constants.dart`)
- **Duration Standards**: Fast (150ms), Normal (300ms), Slow (500ms), Very Slow (800ms)
- **Curve Standards**: EaseOut, EaseInOut, Elastic, Linear
- **Animation Values**: Scale, opacity, and translation constants
- **Accessibility**: Automatically respects reduced motion preferences

### 2. Animated Button (`animated_button.dart`)
- Scale animation on press (0.95 → 1.0)
- Loading state with spinner
- Success state with checkmark
- Performance optimized with proper disposal

### 3. Animated Text Field (`animated_text_field.dart`)
- Scale animation on focus (1.0 → 1.02)
- Smooth border color transitions
- Error state handling
- Respects reduced motion

### 4. Staggered List Animation (`staggered_list_animation.dart`)
- Fade-in animation
- Slide-up animation
- Scale animation
- Staggered delays for list items
- Used in news lists and education screens

### 5. Shimmer Loading (`shimmer_loading.dart`)
- Shimmer effect for loading placeholders
- Customizable colors
- Performance optimized

### 6. Animated Icon Button (`animated_icon_button.dart`)
- Scale animation on press
- Optional rotation animation
- Tooltip support

## Performance Optimizations

1. **RepaintBoundary**: Used to isolate animated widgets
2. **AnimatedBuilder**: Efficient rebuilding during animations
3. **Proper Disposal**: All AnimationControllers are properly disposed
4. **Reduced Motion**: All animations respect accessibility preferences
5. **Duration Control**: Short durations (150-300ms) for better performance

## Usage Examples

### Animated Button
```dart
AnimatedButton(
  onPressed: () => _handleAction(),
  isLoading: _isLoading,
  child: Text('Submit'),
)
```

### Animated Text Field
```dart
AnimatedTextField(
  controller: _emailController,
  labelText: 'Email',
  prefixIcon: Icons.email,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

### Staggered List Animation
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return StaggeredListAnimation(
      index: index,
      child: YourListItem(),
    );
  },
)
```

## Best Practices

1. Always use `RepaintBoundary` for complex animated widgets
2. Keep animation durations short (150-300ms) for better UX
3. Test with reduced motion enabled
4. Dispose AnimationControllers properly
5. Use `AnimatedBuilder` instead of `setState` for animations
6. Avoid animating expensive operations

## Accessibility

All animations automatically check for reduced motion preferences:
- If `MediaQuery.accessibleNavigation` is true
- If `MediaQuery.disableAnimations` is true
- Animations are skipped (duration = 0) when motion should be reduced

