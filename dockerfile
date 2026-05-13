#FROM python:3.14-slim

#ENV PYTHONDONTWRITEBYTECODE=1
#ENV PYTHONUNBUFFERED=1

#WORKDIR /app

#RUN apt-get update \
 #   && apt-get install -y --no-install-recommends \
  #      build-essential \
   #     libpq-dev \
   # && rm -rf /var/lib/apt/lists/*

#COPY pyproject.toml uv.lock ./

#RUN pip install --no-cache-dir uv \
 #   && uv pip install --system --no-cache -r pyproject.toml \
 #   && pip install --no-cache-dir gunicorn

#COPY . .

#RUN mkdir -p /app/staticfiles

#EXPOSE 8000

#CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn QuickPay.wsgi:application --bind 0.0.0.0:8000"]

#FROM python:3.12
# Note: 3.14 is very experimental; 3.12 is safer for production

#ENV PYTHONDONTWRITEBYTECODE=1
#ENV PYTHONUNBUFFERED=1

#WORKDIR /app

#RUN apt-get update \
    #&& apt-get install -y --no-install-recommends \
   #     build-essential \
  #      libpq-dev \
 #   && rm -rf /var/lib/apt/lists/*

# Copy your dependency files from the root
#COPY pyproject.toml uv.lock ./

# Install dependencies into the SYSTEM python so they are available globally
#RUN pip install --no-cache-dir uv \
  #  && uv pip install --system --no-cache . \
 #   && pip install --no-cache-dir gunicorn

# Copy everything
#COPY . .

# CHANGE THE WORKING DIRECTORY TO WHERE MANAGE.PY LIVES
#WORKDIR /app/quick_pay

#RUN mkdir -p /app/staticfiles

#EXPOSE 8000

# Updated CMD with the correct path to your WSGI (traceWallet)
#CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn traceWallet.wsgi:application --bind 0.0.0.0:8000"]


FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install these GLOBALLY first

RUN pip install --no-cache-dir \
    django \
    djangorestframework \
    djangorestframework-simplejwt \
    whitenoise \
    psycopg2-binary \
    requests \
    gunicorn
COPY . .

# Install the rest of your pyproject.toml dependencies globally
RUN pip install --no-cache-dir .

WORKDIR /app/quick_pay
ENV PYTHONPATH=/app/quick_pay
RUN mkdir -p /app/staticfiles

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn traceWallet.wsgi:application --bind 0.0.0.0:8000"]