# Clean Architecture Rules

## 1. Dependency Direction
1. **Dependencies point inward**: Domain layer has no dependencies on frameworks, databases, or external services.
2. **Interface segregation**: Define interfaces at the domain boundary. Infrastructure implements them.
3. **No framework leakage**: Domain entities must not extend framework base classes or import framework packages.

## 2. Layer Boundaries
1. **4 layers**: Domain → Application → Infrastructure → Presentation (UI/API).
2. **No layer skipping**: Presentation talks to Application. Application talks to Domain. Never skip a layer.
3. **DTOs at boundaries**: Use Data Transfer Objects to cross layer boundaries. Do not pass domain entities to the API layer.

## 3. Module Organization
1. **Feature-based folders**: Organize by domain feature (`users/`, `orders/`, `products/`), not by type (`controllers/`, `services/`, `models/`).
2. **Co-locate tests**: Keep tests next to the code they test (`user.service.ts`, `user.service.test.ts`).
