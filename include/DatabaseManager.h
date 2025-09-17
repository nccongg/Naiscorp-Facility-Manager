#pragma once
#include <QObject>
// SQL includes tạm thời comment để tập trung UI
// #include <QSqlDatabase>
// #include <QSqlQuery>
// #include <QSqlError>

class DatabaseManager : public QObject {
  Q_OBJECT
public:
  static DatabaseManager& instance();
  Q_INVOKABLE bool connect();          // đọc ENV và mở QPSQL
  Q_INVOKABLE bool migrate();          // tạo bảng nếu chưa có
  bool checkUserPassword(const QString& username, const QString& password);
  bool createUser(const QString& username, const QString& email, const QString& password);

private:
  explicit DatabaseManager(QObject* parent=nullptr);
  DatabaseManager(const DatabaseManager&)=delete;
  DatabaseManager& operator=(const DatabaseManager&)=delete;

  QString hashPassword(const QString& password, const QString& salt) const;
  QString genSalt() const;

  // QSqlDatabase db_;  // Tạm thời comment để tập trung UI
};
