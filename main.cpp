#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSharedMemory>
#include <QIcon>

#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    app.setOrganizationName("BFLSTiger");
    app.setOrganizationDomain("BFLSTiger.github.com");
    app.setApplicationName("MyMusic");
    app.setWindowIcon(QIcon(":/src/png/MusicLogo.png"));
    QSharedMemory shm(app.applicationName());
    if(!shm.create(1))
    {
        qApp->quit();
        return 0;
    }
    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "MyMusic_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
