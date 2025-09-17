#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "DatabaseManager.h"
#include "AuthController.h"

int main(int argc, char *argv[])
{
    // Set Qt platform plugin explicitly for Raspberry Pi
    qputenv("QT_QPA_PLATFORM", "xcb");
    // Alternative for embedded systems: qputenv("QT_QPA_PLATFORM", "eglfs");
    
    QGuiApplication app(argc, argv);

    // Kết nối DB & migrate (tạm thời mock cho UI)
    DatabaseManager::instance().connect();
    DatabaseManager::instance().migrate();

    QQmlApplicationEngine engine;
    AuthController auth;
    engine.rootContext()->setContextProperty("auth", &auth);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
