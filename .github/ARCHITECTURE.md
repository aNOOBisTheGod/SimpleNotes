# CI/CD Architecture

## GitHub Actions Workflows

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                         │
└─────────────────────────────────────────────────────────────────┘
                                │
                ┌───────────────┼───────────────┐
                │               │               │
                ▼               ▼               ▼
        ┌───────────┐   ┌──────────┐   ┌──────────────┐
        │ Push/PR   │   │ PR Only  │   │  Tag Push    │
        │ main/dev  │   │          │   │  (v*.*.*)    │
        └─────┬─────┘   └────┬─────┘   └──────┬───────┘
              │              │                 │
              ▼              ▼                 ▼
     ┌────────────┐   ┌─────────────┐  ┌──────────────┐
     │  CI/CD     │   │ Quick Check │  │   Release    │
     │  Pipeline  │   │  Workflow   │  │   Workflow   │
     └─────┬──────┘   └──────┬──────┘  └──────┬───────┘
           │                 │                 │
           │                 │                 │
┌──────────┴────────┐        │        ┌────────┴────────────┐
│                   │        │        │                     │
▼          ▼        ▼        ▼        ▼          ▼          ▼
┌────┐  ┌────┐  ┌────┐  ┌────┐    ┌────┐    ┌────┐       ┌────┐
│Ana-│  │Test│  │Build  │Ana-│    │Full│    │Build       │Rel-│
│lyze│  │    │  │    │  │lyze│    │ CI │    │    │       │ease│
└─┬──┘  └─┬──┘  └──┬─┘  └──┬─┘    └─┬──┘    └──┬─┘       └─┬──┘
  │       │        │       │         │          │          │
  │       │        │       ├─────────┤          │          │
  │       │        │       │Parallel │          │          │
  │       │        │       └─────────┘          │          │
  │       │        │                            │          │
  │       │      ┌─▼─────────────┐              │          │
  │       │      │   APK File    │              │          │
  │       │      │   Artifact    │              │          │
  │       │      └───────────────┘              │          │
  │       │                                     │          │
  │       ├─────────────────┐                   │          │
  │       │  Coverage to    │                   │          │
  │       │    Codecov      │                   │          │
  │       └─────────────────┘                   │          │
  │                                             │          │
  └─────────────┬───────────────────────────────┘          │
                │                                          │
                ▼                                          ▼
         ┌─────────────┐                         ┌──────────────┐
         │   Success   │                         │GitHub Release│
         │   Status    │                         │  with APK    │
         └─────────────┘                         └──────────────┘
```

## Docker Container Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Docker Compose                               │
│                  (Orchestration Layer)                           │
└─────────────────────────────────────────────────────────────────┘
                                │
        ┌───────────────────────┼────────────────────────┐
        │                       │                        │
        ▼                       ▼                        ▼
┌───────────────┐      ┌────────────────┐      ┌────────────────┐
│   Analyzer    │      │      Test      │      │    Builder     │
│  Container    │      │   Container    │      │   Container    │
└───────┬───────┘      └────────┬───────┘      └────────┬───────┘
        │                       │                       │
        │ Ubuntu 22.04          │ Ubuntu 22.04          │ Ubuntu 22.04
        │ Flutter 3.24.0        │ Flutter 3.24.0        │ Flutter 3.24.0
        │                       │                       │ Java 17
        │                       │                       │ Android SDK 33
        │                       │                       │ Platform: amd64
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐      ┌────────────────┐      ┌────────────────┐
│ dart format   │      │ flutter test   │      │ flutter build  │
│ flutter       │      │   --coverage   │      │  apk --flavor  │
│   analyze     │      │                │      │      prod      │
└───────┬───────┘      └────────┬───────┘      └────────┬───────┘
        │                       │                       │
        ▼                       ▼                       ▼
    Exit Code              Exit Code              APK File
    (0=success)            (0=success)           (Volume Mount)
                          Coverage Data
                          (Volume Mount)

                               │
                               ▼
                     ┌──────────────────┐
                     │   Integration    │
                     │    Container     │
                     │   (Optional)     │
                     └──────────────────┘
```

## Build Process Flow

```
Developer
    │
    ├─ git commit
    │     │
    │     └─> Git Hook (optional)
    │           └─> make analyze
    │
    ├─ git push
    │     │
    │     └─> GitHub Actions Trigger
    │           │
    │           ├─> Quick Check (PR)
    │           │     └─> Parallel: Analyzer + Test
    │           │
    │           ├─> CI/CD Pipeline (main/develop)
    │           │     │
    │           │     ├─> Stage 1: Analyze
    │           │     │     └─> Docker: analyzer
    │           │     │           └─> dart format + flutter analyze
    │           │     │
    │           │     ├─> Stage 2: Test (parallel with Analyze)
    │           │     │     └─> Docker: test
    │           │     │           └─> flutter test --coverage
    │           │     │                 └─> Upload to Codecov
    │           │     │
    │           │     ├─> Stage 3: Build (after 1+2 success)
    │           │     │     └─> Docker: builder (linux/amd64)
    │           │     │           └─> flutter build apk --flavor prod
    │           │     │                 └─> Upload APK artifact
    │           │     │
    │           │     └─> Stage 4: Integration (disabled)
    │           │           └─> Docker: integration
    │           │
    │           └─> Release (tag push)
    │                 └─> Full Pipeline + GitHub Release
    │
    └─ Local Development
          │
          ├─> make analyze     (Quick feedback)
          ├─> make test        (Quick feedback)
          ├─> make parallel    (Analyzer + Test parallel)
          ├─> make builder     (Full APK build)
          └─> make all         (Complete pipeline)
```

## Caching Strategy

```
┌────────────────────────────────────────────────────────────┐
│                   Docker Layer Cache                        │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  Layer 1: Base Image (ubuntu:22.04)                        │
│     │                                                       │
│     ├─> Cached: Always (rarely changes)                    │
│     │                                                       │
│  Layer 2: System Dependencies                              │
│     │    (curl, git, unzip, openjdk-17, etc.)             │
│     ├─> Cached: Always (rarely changes)                    │
│     │                                                       │
│  Layer 3: Flutter SDK Installation                         │
│     │    (git clone flutter stable)                        │
│     ├─> Cached: Until Flutter version changes              │
│     │                                                       │
│  Layer 4: Flutter Precache & Config                        │
│     │                                                       │
│     ├─> Cached: Until Flutter version changes              │
│     │                                                       │
│  Layer 5: pubspec.yaml + pubspec.lock                      │
│     │                                                       │
│     ├─> Cached: Until dependencies change                  │
│     │                                                       │
│  Layer 6: flutter pub get                                  │
│     │                                                       │
│     ├─> Cached: Until pubspec.lock changes                 │
│     │    KEY: This is the most important cache layer!      │
│     │                                                       │
│  Layer 7: Copy source code                                 │
│     │                                                       │
│     └─> Never Cached: Changes with every commit            │
│                                                             │
└────────────────────────────────────────────────────────────┘

GitHub Actions Cache:
    Key: ${{ runner.os }}-buildx-${{ service }}-${{ hashFiles(...) }}
    
    Invalidates when:
        - Dockerfile changes
        - pubspec.lock changes
        - OS changes (ubuntu → other)
```

## Dependency Flow

```
docker-compose.yml
    │
    ├─> analyzer (no dependencies)
    │     └─> Can run immediately
    │
    ├─> test (no dependencies)
    │     └─> Can run immediately
    │
    ├─> builder (depends_on: analyzer, test)
    │     └─> Waits for analyzer + test to succeed
    │           └─> Then builds APK
    │
    └─> integration (depends_on: builder)
          └─> Waits for builder to succeed
                └─> Then runs integration tests
```

## Makefile Command Tree

```
make
  ├─ help           (Show available commands)
  ├─ build          (Build all Docker images)
  ├─ analyze        (Run analyzer container)
  ├─ test           (Run test container)
  ├─ builder        (Run builder container)
  ├─ integration    (Run integration container)
  ├─ all            (Sequential: analyze → test → builder → integration)
  ├─ parallel       (Parallel: analyzer + test)
  ├─ up             (Start all containers)
  ├─ down           (Stop all containers)
  ├─ clean          (Remove containers + volumes)
  ├─ logs           (Show container logs)
  ├─ extract-apk    (Copy APK from builder container)
  └─ extract-coverage (Copy coverage from test container)
```
