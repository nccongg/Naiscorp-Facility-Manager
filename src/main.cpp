#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    // Set Qt platform plugin explicitly for Raspberry Pi
    qputenv("QT_QPA_PLATFORM", "xcb");
    // Alternative for embedded systems: qputenv("QT_QPA_PLATFORM", "eglfs");
    
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);  // Đổi từ DirectConnection sang QueuedConnection
    engine.load(url);

    return app.exec();
}
