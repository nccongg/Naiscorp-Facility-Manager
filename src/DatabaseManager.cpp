#include "DatabaseManager.h"
#include <QCryptographicHash>
#include <QRandomGenerator>
#include <QVariant>
#include <QDebug>
#include <QProcessEnvironment>

DatabaseManager::DatabaseManager(QObject* parent) : QObject(parent) {}

DatabaseManager& DatabaseManager::instance() {
  static DatabaseManager inst;
  return inst;
}

bool DatabaseManager::connect() {
#ifdef HAVE_QT_SQL
  // 1) Kiểm tra driver
  if (!QSqlDatabase::isDriverAvailable("QPSQL")) {
    qWarning() << "[DB] QPSQL driver not available (install libqt5sql5-psql)";
    return false;
  }

  // 2) Dùng connection name để tránh addDatabase nhiều lần
  const QString kConnName = QStringLiteral("facility_conn");
  if (QSqlDatabase::contains(kConnName)) {
    db_ = QSqlDatabase::database(kConnName);
    if (db_.isOpen()) {
      qInfo() << "[DB] Already connected";
      return true;
    }
  } else {
    db_ = QSqlDatabase::addDatabase("QPSQL", kConnName);
  }

  // 3) Đọc ENV (đủ để deploy/đổi cấu hình)
  auto env = QProcessEnvironment::systemEnvironment();
  const QString host = env.value("DB_HOST", "localhost");
  const QString name = env.value("DB_NAME", "facility_db");
  const QString user = env.value("DB_USER", "postgres");
  const QString pass = env.value("DB_PASS", "1");   // chỉnh lại cho đúng máy bạn
  const int     port = env.value("DB_PORT", "5432").toInt();

  db_.setHostName(host);
  db_.setPort(port);
  db_.setDatabaseName(name);
  db_.setUserName(user);
  db_.setPassword(pass);

  if (!db_.open()) {
    qWarning() << "[DB] Connection failed:" << db_.lastError().text();
    qWarning() << "[DB] host=" << host << " port=" << port << " db=" << name << " user=" << user;
    return false;
  }

  qInfo() << "[DB] Connected: host=" << host << " db=" << name << " user=" << user;

  QSqlQuery vq(db_);
  if (vq.exec("SELECT version()") && vq.next())
    qInfo() << "[DB] Version:" << vq.value(0).toString();

  return true;
#else
  qWarning() << "[DB] Qt Sql disabled (no HAVE_QT_SQL)";
  return false;
#endif
}

bool DatabaseManager::migrate() {
#ifdef HAVE_QT_SQL
  if (!db_.isOpen()) {
    qWarning() << "[DB] migrate(): not connected";
    return false;
  }
  QSqlQuery q(db_);

  qInfo() << "[DB] Creating table: users";
  if (!q.exec(R"SQL(
    CREATE TABLE IF NOT EXISTS public.users (
      id SERIAL PRIMARY KEY,
      username VARCHAR(50) UNIQUE NOT NULL,
      email VARCHAR(100),
      password_hash VARCHAR(256) NOT NULL,
      salt VARCHAR(64) NOT NULL,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  )SQL")) {
    qWarning() << "[DB] users failed:" << q.lastError().text();
    return false;
  }

  qInfo() << "[DB] Creating table: assets";
  if (!q.exec(R"SQL(
    CREATE TABLE IF NOT EXISTS public.assets (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      location VARCHAR(100),
      status VARCHAR(50),
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  )SQL")) {
    qWarning() << "[DB] assets failed:" << q.lastError().text();
    return false;
  }

  qInfo() << "[DB] Migration OK";
  return true;
#else
  qInfo() << "[DB] migrate(): mock OK";
  return true;
#endif
}

QString DatabaseManager::genSalt() const {
  QByteArray r(16, Qt::Uninitialized);
  for (int i = 0; i < r.size(); ++i)
    r[i] = static_cast<char>(QRandomGenerator::global()->generate() & 0xFF);
  return r.toHex();
}

QString DatabaseManager::hashPassword(const QString& password, const QString& salt) const {
  const QByteArray input = (salt + password).toUtf8();
  return QCryptographicHash::hash(input, QCryptographicHash::Sha256).toHex();
}

bool DatabaseManager::createUser(const QString& username, const QString& email, const QString& password) {
#ifdef HAVE_QT_SQL
  if (!db_.isOpen()) {
    qWarning() << "[DB] createUser(): not connected";
    return false;
  }
  if (username.isEmpty() || password.isEmpty()) {
    qWarning() << "[DB] createUser(): empty username/password";
    return false;
  }

  const QString salt = genSalt();
  const QString hash = hashPassword(password, salt);

  QSqlQuery q(db_);
  q.prepare("INSERT INTO public.users(username,email,password_hash,salt) VALUES(:u,:e,:p,:s)");
  q.bindValue(":u", username);
  q.bindValue(":e", email);
  q.bindValue(":p", hash);
  q.bindValue(":s", salt);

  if (!q.exec()) {
    const auto err = q.lastError().text();
    qWarning() << "[DB] createUser() failed:" << err;
    return false;
  }

  qInfo() << "[DB] User created:" << username;
  return true;
#else
  qInfo() << "[DB] createUser(): mock";
  return true;
#endif
}

bool DatabaseManager::checkUserPassword(const QString& username, const QString& password) {
#ifdef HAVE_QT_SQL
  if (!db_.isOpen()) {
    qWarning() << "[DB] checkUserPassword(): not connected";
    return false;
  }

  QSqlQuery q(db_);
  q.prepare("SELECT password_hash, salt FROM public.users WHERE username = :u");
  q.bindValue(":u", username);

  if (!q.exec()) {
    qWarning() << "[DB] checkUserPassword() query failed:" << q.lastError().text();
    return false;
  }
  if (!q.next()) {
    qInfo() << "[DB] user not found:" << username;
    return false;
  }

  const QString storedHash = q.value(0).toString();
  const QString salt       = q.value(1).toString();
  const QString inputHash  = hashPassword(password, salt);

  const bool ok = (storedHash == inputHash);
  qInfo() << "[DB] password check" << username << (ok ? "OK" : "FAIL");
  return ok;
#else
  qInfo() << "[DB] checkUserPassword(): mock";
  return (username == "admin" && password == "admin");
#endif
}

void DatabaseManager::testConnection() {
#ifdef HAVE_QT_SQL
  qInfo() << "[DB] ===== TEST =====";
  if (!db_.isOpen()) {
    qWarning() << "[DB] not connected -> try connect()";
    if (!connect()) { qWarning() << "[DB] connect() failed"; return; }
  }

  QSqlQuery q(db_);
  if (q.exec("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")) {
    qInfo() << "[DB] tables:";
    while (q.next()) qInfo() << "  -" << q.value(0).toString();
  } else {
    qWarning() << "[DB] list tables failed:" << q.lastError().text();
  }

  if (q.exec("SELECT COUNT(*) FROM public.users") && q.next())
    qInfo() << "[DB] users count =" << q.value(0).toInt();

  qInfo() << "[DB] ===== END TEST =====";
#else
  qInfo() << "[DB] testConnection(): mock";
#endif
}
