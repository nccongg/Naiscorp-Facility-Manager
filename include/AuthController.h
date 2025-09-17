#pragma once
#include <QObject>

class AuthController : public QObject {
  Q_OBJECT
public:
  explicit AuthController(QObject* parent=nullptr);

  Q_INVOKABLE bool login(const QString& username, const QString& password);
  Q_INVOKABLE bool signup(const QString& username, const QString& email, const QString& password);

signals:
  void loginSucceeded();
  void loginFailed(const QString& reason);
  void signupSucceeded();
  void signupFailed(const QString& reason);
};
