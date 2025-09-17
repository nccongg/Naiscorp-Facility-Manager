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
  // TẠM THỜI BỎ QUA DATABASE - trả về true để UI hoạt động
  qInfo() << "[DB] Mock connection - database temporarily disabled for UI focus";
  return true;
  
  /* Original database connection code (commented out for UI focus)
  if (db_.isValid() && db_.isOpen()) return true;

  auto env = QProcessEnvironment::systemEnvironment();
  const QString host = env.value("DB_HOST", "localhost");
  const QString name = env.value("DB_NAME", "facility_db");
  const QString user = env.value("DB_USER", "pi_user");
  const QString pass = env.value("DB_PASS", "password");
  const QString portStr = env.value("DB_PORT", "5432");

  db_ = QSqlDatabase::addDatabase("QPSQL");
  db_.setHostName(host);
  db_.setPort(portStr.toInt());
  db_.setDatabaseName(name);
  db_.setUserName(user);
  db_.setPassword(pass);

  if (!db_.open()) {
    qWarning() << "[DB] open failed:" << db_.lastError().text();
    return false;
  }
  qInfo() << "[DB] connected to" << host << name;
  return true;
  */
}

bool DatabaseManager::migrate() {
  // TẠM THỜI BỎ QUA DATABASE MIGRATION
  qInfo() << "[DB] Mock migration - database temporarily disabled for UI focus";
  return true;
  
  /* Original migration code (commented out for UI focus)
  if (!db_.isOpen()) return false;

  QSqlQuery q(db_);
  // users
  if (!q.exec(R"SQL(
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username VARCHAR(50) UNIQUE NOT NULL,
      email VARCHAR(100),
      password_hash VARCHAR(256) NOT NULL,
      salt VARCHAR(64) NOT NULL,
      created_at TIMESTAMP DEFAULT NOW()
    );
  )SQL")) {
    qWarning() << "[DB] migrate users failed:" << q.lastError().text();
    return false;
  }

  // assets
  if (!q.exec(R"SQL(
    CREATE TABLE IF NOT EXISTS assets (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      location VARCHAR(100),
      status VARCHAR(50),
      created_at TIMESTAMP DEFAULT NOW()
    );
  )SQL")) {
    qWarning() << "[DB] migrate assets failed:" << q.lastError().text();
    return false;
  }

  return true;
  */
}

QString DatabaseManager::genSalt() const {
  QByteArray r(16, Qt::Uninitialized);
  quint32* data = reinterpret_cast<quint32*>(r.data());
  quint32* end = data + (r.size()/sizeof(quint32));
  QRandomGenerator::global()->generate(data, end);
  return r.toHex();
}

QString DatabaseManager::hashPassword(const QString& password, const QString& salt) const {
  QByteArray input = (salt + password).toUtf8();
  auto hash = QCryptographicHash::hash(input, QCryptographicHash::Sha256);
  return hash.toHex();
}

bool DatabaseManager::createUser(const QString& username, const QString& email, const QString& password) {
  // MOCK DATA cho UI testing
  qInfo() << "[DB] Mock createUser:" << username << email;
  
  // Simulate some basic validation
  if (username.isEmpty() || password.isEmpty()) {
    qWarning() << "[DB] createUser failed: empty username or password";
    return false;
  }
  
  // Always succeed for UI testing
  return true;
  
  /* Original database code (commented out for UI focus)
  if (!db_.isOpen()) return false;
  const QString salt = genSalt();
  const QString h = hashPassword(password, salt);

  QSqlQuery q(db_);
  q.prepare("INSERT INTO users(username,email,password_hash,salt) VALUES(:u,:e,:p,:s)");
  q.bindValue(":u", username);
  q.bindValue(":e", email);
  q.bindValue(":p", h);
  q.bindValue(":s", salt);
  if (!q.exec()) {
    qWarning() << "[DB] createUser failed:" << q.lastError().text();
    return false;
  }
  return true;
  */
}

bool DatabaseManager::checkUserPassword(const QString& username, const QString& password) {
  // MOCK DATA cho UI testing
  qInfo() << "[DB] Mock checkUserPassword:" << username;
  
  // Simple mock logic: accept "admin/admin" và "test/test"
  if ((username == "admin" && password == "admin") || 
      (username == "test" && password == "test")) {
    return true;
  }
  
  return false;
  
  /* Original database code (commented out for UI focus)
  if (!db_.isOpen()) return false;
  QSqlQuery q(db_);
  q.prepare("SELECT password_hash, salt FROM users WHERE username=:u");
  q.bindValue(":u", username);
  if (!q.exec() || !q.next()) return false;
  const auto hash = q.value(0).toString();
  const auto salt = q.value(1).toString();
  return hash == hashPassword(password, salt);
  */
}
