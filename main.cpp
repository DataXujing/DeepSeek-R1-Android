/*-------------------------------------------------
#
# Url:https://shazhenyu.blog.csdn.net/article/details/81505832
# Github:https://github.com/ShaShiDiZhuanLan/Demo_MessageChat_Qt
#
#-------------------------------------------------*/
#include "mainwindow.h"
#include <QApplication>

#include "llm/llm.hpp"
#include <QDebug>
#include <QFile>
#include <QDir>

using namespace MNN::Transformer;
using namespace MNN;

std::unique_ptr<Llm> llm(nullptr);


bool copyDirectoryFiles(const QString &fromDir, const QString &toDir, bool coverFileIfExist)
{
    QDir sourceDir(fromDir);
    QDir targetDir(toDir);
    if(!targetDir.exists()){    /**< 如果目标目录不存在，则进行创建 */
        if(!targetDir.mkdir(targetDir.absolutePath()))
            return false;
    }

    QFileInfoList fileInfoList = sourceDir.entryInfoList();
    foreach(QFileInfo fileInfo, fileInfoList){
        if(fileInfo.fileName() == "." || fileInfo.fileName() == "..")
            continue;

        if(fileInfo.isDir()){    /**< 当为目录时，递归的进行copy */
            if(!copyDirectoryFiles(fileInfo.filePath(),
                targetDir.filePath(fileInfo.fileName()),
                coverFileIfExist))
                return false;
        }
        else{            /**< 当允许覆盖操作时，将旧文件进行删除操作 */
            if(coverFileIfExist && targetDir.exists(fileInfo.fileName())){
                targetDir.remove(fileInfo.fileName());
            }

            /// 进行文件copy
            if(!QFile::copy(fileInfo.filePath(),
                targetDir.filePath(fileInfo.fileName()))){
                    return false;
            }
        }
    }
    return true;
}


int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //模型加载放在main函数
    //std::string model_dir ="assets:/models";
    copyDirectoryFiles("assets:/models","models", false);
    if (!llm.get()) {
        llm.reset(Llm::createLLM("models/config.json"));
        llm->load();
        qDebug() << "--------->>>>: DeepSeek-R1 1.5B 模型加载完成";
    }

    MainWindow w;
    w.show();

    return a.exec();
}
