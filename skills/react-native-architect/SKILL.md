---
name: react-native-architect
description: >-
  Use when the user is building a React Native app, using Expo, structuring a mobile app with React Navigation, handling native modules, debugging Metro bundler errors, or optimizing React Native performance.
---

# React Native Architect

Build production React Native apps with Expo, proper navigation, and native performance.

## Step 1 — Project Setup (Expo Recommended)
```bash
npx create-expo-app@latest MyApp --template blank-typescript
cd MyApp
npx expo install expo-router react-native-safe-area-context react-native-screens
```

## Step 2 — Expo Router File-Based Navigation
```
app/
  _layout.tsx       # Root layout — Stack or Tabs
  (tabs)/
    _layout.tsx     # Tab navigator
    index.tsx       # Home tab
    profile.tsx     # Profile tab
  (auth)/
    login.tsx
    register.tsx
  modal.tsx         # Modal screen
```

```tsx
// app/_layout.tsx
import { Stack } from 'expo-router';

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
    </Stack>
  );
}
```

## Step 3 — State Management with Zustand
```typescript
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface AuthState {
  token: string | null;
  user: User | null;
  setAuth: (token: string, user: User) => void;
  clearAuth: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      setAuth: (token, user) => set({ token, user }),
      clearAuth: () => set({ token: null, user: null }),
    }),
    { name: 'auth-storage', storage: createJSONStorage(() => AsyncStorage) }
  )
);
```

## Step 4 — Performance: FlatList and Memoization
```tsx
// Always use FlatList for long lists — never ScrollView + map
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={({ item }) => <ItemCard item={item} />}
  initialNumToRender={10}
  maxToRenderPerBatch={10}
  windowSize={5}
  removeClippedSubviews={true}
/>

// Memoize expensive components
const ItemCard = React.memo(({ item }: { item: Item }) => (
  <View style={styles.card}>
    <Text>{item.title}</Text>
  </View>
));
```

## Step 5 — Native Module Patterns
```typescript
// Check platform before using native APIs
import { Platform, Linking } from 'react-native';

const openSettings = () => {
  if (Platform.OS === 'ios') {
    Linking.openURL('app-settings:');
  } else {
    Linking.openSettings();
  }
};
```

## Step 6 — Debug Metro Bundler Errors
```bash
# Clear all caches
npx expo start --clear

# Reset Metro cache
npx react-native start --reset-cache

# Check for version conflicts
npx expo doctor
```

## Verification Checklist
- [ ] FlatList used (not ScrollView + map) for lists > 20 items
- [ ] Images use `<Image>` with explicit width/height (no layout thrash)
- [ ] AsyncStorage accessed only in store/service layer, not in components
- [ ] `npx expo doctor` reports no issues
- [ ] Tested on both iOS and Android simulators
