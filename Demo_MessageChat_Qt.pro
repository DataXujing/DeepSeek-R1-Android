#-------------------------------------------------
#xujing 2025-02-01
#
#-------------------------------------------------
QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Demo_MessageChat
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    chatmessage/qnchatmessage.cpp

HEADERS  += mainwindow.h \
    chatmessage/qnchatmessage.h

FORMS    += mainwindow.ui

RESOURCES += \
    img.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    model/config.json \
    model/embeddings_bf16.bin \
    model/llm.mnn \
    model/llm.mnn.json \
    model/llm.mnn.weight \
    model/llm_config.json \
    model/tokenizer.txt \


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android


android {
  data.files += model/config.json
  data.files += model/embeddings_bf16.bin
  data.files += model/llm.mnn
  data.files += model/llm.mnn.json
  data.files += model/llm.mnn.weight
  data.files += model/llm_config.json
  data.files += model/tokenizer.txt

  data.path = /assets/models
  INSTALLS += data

}

unix:!macx: LIBS += -L$$PWD/../MNN-3.0.0/project/android/build_32/ -lllm
unix:!macx: LIBS += -L$$PWD/../MNN-3.0.0/project/android/build_32/ -lMNN
unix:!macx: LIBS += -L$$PWD/../MNN-3.0.0/project/android/build_32/ -lMNN_CL
unix:!macx: LIBS += -L$$PWD/../MNN-3.0.0/project/android/build_32/ -lMNN_Express

INCLUDEPATH += $$PWD/../MNN-3.0.0/include
DEPENDPATH += $$PWD/../MNN-3.0.0/include

INCLUDEPATH += $$PWD/../MNN-3.0.0/transformers/llm/engine/include
DEPENDPATH += $$PWD/../MNN-3.0.0/transformers/llm/engine/include

ANDROID_EXTRA_LIBS = $$PWD/../MNN-3.0.0/project/android/build_32/libllm.so $$PWD/../MNN-3.0.0/project/android/build_32/libMNN.so $$PWD/../MNN-3.0.0/project/android/build_32/libMNN_CL.so $$PWD/../MNN-3.0.0/project/android/build_32/libMNN_Express.so
