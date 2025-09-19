#pragma once
#include <QObject>
#include <QString>

#ifdef HAVE_QT_SQL
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#endif

class DatabaseManager : public QObject {
  Q_OBJECT
public:
  static DatabaseManager& instance();

  Q_INVOKABLE bool connect();          // đọc ENV và mở QPSQL
  Q_INVOKABLE bool migrate();          // tạo bảng nếu chưa có
  Q_INVOKABLE void testConnection();   // test kết nối và in info

  bool createUser(const QString& username, const QString& email, const QString& password);
  bool checkUserPassword(const QString& username, const QString& password);

private:
  explicit DatabaseManager(QObject* parent = nullptr);
  DatabaseManager(const DatabaseManager&) = delete;
  DatabaseManager& operator=(const DatabaseManager&) = delete;

  QString genSalt() const;
  QString hashPassword(const QString& password, const QString& salt) const;

#ifdef HAVE_QT_SQL
  QSqlDatabase db_;
#endif
};
