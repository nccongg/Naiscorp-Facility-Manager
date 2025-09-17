#include "AuthController.h"
#include "DatabaseManager.h"

AuthController::AuthController(QObject* parent) : QObject(parent) {}

bool AuthController::login(const QString& u, const QString& p) {
  if (!DatabaseManager::instance().connect()) {
    emit loginFailed("Database not connected");
    return false;
  }
  const bool ok = DatabaseManager::instance().checkUserPassword(u, p);
  if (ok) emit loginSucceeded(); else emit loginFailed("Invalid credentials");
  return ok;
}

bool AuthController::signup(const QString& u, const QString& e, const QString& p) {
  if (!DatabaseManager::instance().connect()) {
    emit signupFailed("Database not connected");
    return false;
  }
  const bool ok = DatabaseManager::instance().createUser(u, e, p);
  if (ok) emit signupSucceeded(); else emit signupFailed("Cannot create user");
  return ok;
}
