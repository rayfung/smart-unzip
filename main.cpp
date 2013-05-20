#include <QString>
#include <QTextCodec>
#include <QTextStream>
#include <QByteArray>
#include <iostream>
#include <stdio.h>
#include <string.h>

using namespace std;

QString conv(const char *str, const char *name)
{
    QTextCodec *codec = QTextCodec::codecForName(name);
    QByteArray encodedData(str);
    QString decodedStr;

    QTextStream in(&encodedData);
    in.setAutoDetectUnicode(false);
    in.setCodec(codec);
    decodedStr = in.readAll();
    return decodedStr;
}

int main(int argc, char *argv[])
{
    QString fileName;
    bool notest = false;

    if(argc >= 3)
    {
        if(strcmp(argv[1], "notest") == 0)
            notest = true;
        else if(strcmp(argv[1], "t") == 0)
            notest = false;
        else
        {
            cout << "operation error" << endl;
            return 1;
        }
    }
    else
    {
        cout << "missing files" << endl;
        return 1;
    }

    for(int idx = 2; idx < argc; ++idx)
    {
        cout << (fileName = conv(argv[idx], "GB18030")).toUtf8().data();
        if(notest)
        {
            if(rename(argv[idx], fileName.toUtf8().data()) == 0) cout << "\t[OK]";
            else cout << "\t[ERR]";
        }
        cout << endl;
    }
    return 0;
}
