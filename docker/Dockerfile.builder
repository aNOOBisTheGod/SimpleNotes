# Dockerfile для сборки Flutter приложения
FROM ubuntu:22.04

# Устанавливаем переменные окружения
ENV FLUTTER_VERSION=3.24.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    mv cmdline-tools latest && \
    rm commandlinetools-linux-9477386_latest.zip

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Принимаем лицензии Android SDK
RUN yes | sdkmanager --licenses || true

# Устанавливаем необходимые компоненты Android SDK
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Скачиваем и устанавливаем Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}

# Предварительная настройка Flutter
RUN flutter precache
RUN flutter config --no-analytics
RUN flutter doctor

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY pubspec.yaml pubspec.lock ./
COPY l10n.yaml ./
COPY analysis_options.yaml ./

# Копируем l10n файлы ДО pub get (требуется для генерации локализаций)
COPY lib/l10n ./lib/l10n

# Получаем зависимости
RUN flutter pub get

# Копируем остальные файлы
COPY . .

# Собираем APK для prod flavor
CMD ["flutter", "build", "apk", "--release", "--flavor", "prod"]
