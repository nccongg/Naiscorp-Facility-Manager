-- Chạy bằng:  psql -U postgres -f setup_database.sql
-- (Bạn đã có facility_db rồi thì có thể bỏ 2 dòng CREATE/CONNECT đầu)

-- Tạo database (bạn đã có rồi thì bỏ qua; PostgreSQL không hỗ trợ IF NOT EXISTS ở đây)
-- CREATE DATABASE facility_db;

-- Kết nối vào DB (chỉ dùng khi chạy qua psql CLI)
\c facility_db;

BEGIN;

-- Bảng users
CREATE TABLE IF NOT EXISTS public.users (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100),
    password_hash VARCHAR(256) NOT NULL,
    salt          VARCHAR(64)  NOT NULL,
    created_at    TIMESTAMPTZ  DEFAULT NOW()
);

-- Bảng assets
CREATE TABLE IF NOT EXISTS public.assets (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    location   VARCHAR(100),
    status     VARCHAR(50),
    created_at TIMESTAMPTZ  DEFAULT NOW()
);

COMMIT;

-- Kiểm tra nhanh
\dt public.*
SELECT '✓ Database setup completed' AS message;
