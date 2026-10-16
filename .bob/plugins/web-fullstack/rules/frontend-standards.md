# Frontend Standards

## 1. Component Design
1. **Single responsibility**: Each component renders one thing. Split when a component has more than one reason to change.
2. **Props over state**: Derive values from props instead of syncing them into state. Avoid `useEffect` for derived state.
3. **Accessible by default**: Every interactive element must be keyboard accessible and have proper ARIA labels.

## 2. CSS & Styling
1. **Mobile-first**: Write base styles for mobile, then use `min-width` media queries to enhance for larger screens.
2. **No magic numbers**: Use CSS custom properties (`--spacing-4`) instead of hardcoded pixel values.
3. **Semantic HTML**: Use `<button>` for actions, `<a>` for navigation, `<form>` for inputs — not `<div>` for everything.

## 3. Performance
1. **Lazy load routes**: All routes must be code-split. Use `React.lazy()` or Next.js dynamic imports.
2. **Optimize images**: Use `next/image` or equivalent. Never serve full-resolution images to mobile.
3. **No layout thrash**: Avoid reading `offsetHeight` immediately after a DOM write.
