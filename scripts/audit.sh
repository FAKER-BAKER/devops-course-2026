
# [5] Контейнеризация
echo "[5] Контейнеризация"
APP_DIR="${APP_DIR:-$(getent passwd "${SUDO_USER:-$(id -un)}" | cut -d: -f6)/app}"
DB_CONTAINER="${DB_CONTAINER:-app-db-1}"

check "Служба docker активна" "active" "$(systemctl is-active docker)"
check "Контейнер СУБД в состоянии healthy" "healthy" "$(docker inspect -f '{{.State.Health.Status}}' "${DB_CONTAINER}" 2>/dev/null)"
check "Порты 5000 и 5432 слушаются только на 127.0.0.1" "0" "$(ss -tln | awk '$4 ~ /:(5000|5432)$/ && $4 !~ /^127\.0\.0\.1:/' | wc -l)"
check "Права файла .env равны 600" "600" "$(stat -c '%a' "${APP_DIR}/.env" 2>/dev/null)"