FROM python:3.11-slim

# Muhit
ENV TZ=Asia/Tashkent \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Tizim paketlari (Playwright Chromium uchun)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc g++ make curl wget tzdata \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 \
    libpango-1.0-0 libcairo2 libatspi2.0-0 \
    fonts-liberation fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Avval faqat requirements — Docker layer cache uchun
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Playwright Chromium o'rnatish
RUN playwright install chromium --with-deps 2>/dev/null || playwright install chromium

# Kod va JSON fayllar
COPY . .

# /data papkasini yaratamiz (Railway Volume bu path ga mount qiladi)
RUN mkdir -p /data

CMD ["python", "main.py"]
