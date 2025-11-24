# GitHub Actions CI/CD

Автоматизированная система непрерывной интеграции и доставки для SimpleNotes.

## 🚀 Workflows

### [`ci-cd.yml`](workflows/ci-cd.yml) - Основной CI/CD Pipeline
**Триггеры:** Push в `main`/`develop`, Pull Requests, Tags `v*.*.*`

**Этапы:**
1. **Code Analysis** - Статический анализ и форматирование
2. **Unit Tests** - Запуск тестов с покрытием
3. **Build APK** - Сборка production APK
4. **Create Release** - Автоматический релиз (только для main и тегов)

**Артефакты:**
- APK файл (30 дней хранения)
- Coverage report (отправляется в Codecov)
- GitHub Release (для main и тегов)

---

### [`release.yml`](workflows/release.yml) - Release Build
**Триггеры:** Push тега `v*.*.*`

**Описание:** Полный CI/CD pipeline с созданием стабильного релиза

**Вывод:**
- GitHub Release с подробным описанием
- Production APK файл
- Информация о версии и сборке

---

### [`quick-check.yml`](workflows/quick-check.yml) - Быстрая проверка
**Триггеры:** Pull Requests

**Описание:** Параллельный запуск анализа и тестов для быстрой обратной связи

**Время выполнения:** ~5-7 минут

---

## 📦 Создание релиза

### Автоматический релиз через тег:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Автоматический development релиз:
```bash
git push origin main
```

Подробнее: [RELEASES.md](RELEASES.md)

---

## 🏗️ Архитектура

```
┌─────────────┐
│   GitHub    │
│  Repository │
└──────┬──────┘
       │
       ├──────────────┬─────────────┬────────────┐
       │              │             │            │
       ▼              ▼             ▼            ▼
   CI/CD.yml    release.yml   quick-check   [Manual]
       │              │             │
       ├──────────────┴─────────────┤
       │                            │
       ▼                            ▼
  ┌─────────┐                ┌──────────┐
  │ Docker  │                │  GitHub  │
  │Compose  │                │ Release  │
  └────┬────┘                └─────┬────┘
       │                           │
  ┌────┴────┬──────┬──────┐       │
  │         │      │      │       │
  ▼         ▼      ▼      ▼       ▼
Analyze   Test  Build  Integ.  📱 APK
```

Подробнее: [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🛠️ Docker Containers

Все этапы выполняются в изолированных Docker контейнерах:

| Контейнер | Назначение | Время сборки |
|-----------|-----------|--------------|
| `analyzer` | Статический анализ кода | ~10-30s |
| `test` | Unit тесты + coverage | ~5-10s |
| `builder` | Сборка production APK | ~10-15 min |
| `integration` | Интеграционные тесты | ~25-35s |

---

## 📊 Статусы

- ✅ **All Checks Passed** - Код готов к merge
- ⚠️ **Some Checks Failed** - Требуется исправление
- 🔄 **In Progress** - Выполняется проверка
- ❌ **Failed** - Критическая ошибка

---

## 🔧 Локальное использование

```bash
# Установка
make help

# Запуск всего pipeline
make all

# Отдельные команды
make analyze    # Анализ кода
make test       # Тесты
make builder    # Сборка APK
make integration # Интеграционные тесты

# Извлечь APK
make extract-apk
```

---

## 📝 Конфигурация

### Необходимые секреты:
- `GITHUB_TOKEN` - автоматически предоставляется GitHub
- `CODECOV_TOKEN` - (опционально) для отправки coverage

### Permissions:
```yaml
permissions:
  contents: write  # Для создания релизов
```

### Volumes:
```bash
# Создаются автоматически workflows
flutter-build-output     # APK файлы
flutter-test-coverage    # Coverage данные
```

---

## 📚 Документация

- [RELEASES.md](RELEASES.md) - Процесс релизов
- [ARCHITECTURE.md](ARCHITECTURE.md) - Архитектура системы
- [Makefile](../Makefile) - Локальные команды
- [Docker Compose](../docker/docker-compose.yml) - Конфигурация контейнеров

---

## 🐛 Troubleshooting

### Volume не найден
```bash
docker volume create flutter-build-output
docker volume create flutter-test-coverage
```

### Сборка APK упала
Проверьте:
1. Версии Gradle/AGP в `android/` папке
2. Логи GitHub Actions
3. Доступность Docker volumes

### Тесты не проходят локально
```bash
# Пересоберите контейнер
make clean
docker compose -f docker/docker-compose.yml build --no-cache test
make test
```

---

## 🎯 Best Practices

1. **Всегда создавайте PR** перед merge в main
2. **Используйте семантическое версионирование** для тегов
3. **Проверяйте локально** перед push: `make all`
4. **Пишите понятные commit messages**
5. **Добавляйте changelog** в описание релиза

---

Made with ❤️ using Docker + GitHub Actions
