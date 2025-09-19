#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "DatabaseManager.h"
#include "AuthController.h"

int main(int argc, char *argv[])
{
    // Nếu bạn chắc chắn Pi dùng X11 thì "xcb"; nếu EGL/FB thì "eglfs".
    // qputenv("QT_QPA_PLATFORM", "xcb");

    QGuiApplication app(argc, argv);

    qInfo() << "=== DB init ===";
    if (DatabaseManager::instance().connect()) {
        DatabaseManager::instance().migrate();
        DatabaseManager::instance().testConnection();
    } else {
        qWarning() << "DB not connected. App continues without DB.";
    }

    QQmlApplicationEngine engine;
    AuthController auth;
    engine.rootContext()->setContextProperty("auth", &auth);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject *obj, const QUrl &objUrl) {
                       if (!obj && url == objUrl) QCoreApplication::exit(-1);
                     },
                     Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
