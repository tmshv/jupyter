FROM python:3.7-alpine3.9

#RUN echo -e '@edgunity http://nl.alpinelinux.org/alpine/edge/community\n\
#@edge http://nl.alpinelinux.org/alpine/edge/main\n\
#@testing http://nl.alpinelinux.org/alpine/edge/testing\n\
#@community http://dl-cdn.alpinelinux.org/alpine/edge/community'\
#>> /etc/apk/repositories

RUN apk add --update --no-cache \
    build-base \
    openblas-dev \
    unzip \
    wget \
    cmake \

    #Intel® TBB, a widely used C++ template library for task parallelism'
    #libtbb@testing \
    #libtbb-dev@testing \

    # Wrapper for libjpeg-turbo
    libjpeg \

    # accelerated baseline JPEG compression and decompression library
    libjpeg-turbo-dev \

    # Portable Network Graphics library
    libpng-dev \

    # A software-based implementation of the codec specified in the emerging JPEG-2000 Part-1 standard (development files)
    jasper-dev \

    # Provides support for the Tag Image File Format or TIFF (development files)
    tiff-dev \

    # Libraries for working with WebP images (development files)
    libwebp-dev \

    # A C language family front-end for LLVM (development files)
    clang-dev \

    linux-headers 

RUN pip install numpy 

ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

ENV OPENCV_VERSION=4.1.2

RUN cd /opt && \
	wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
	unzip ${OPENCV_VERSION}.zip && \
	rm -rf ${OPENCV_VERSION}.zip

RUN mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
    cd /opt/opencv-${OPENCV_VERSION}/build && \
    cmake \
   -D CMAKE_BUILD_TYPE=RELEASE \
   -D CMAKE_INSTALL_PREFIX=/usr/local \
   -D WITH_FFMPEG=NO \
   -D WITH_IPP=NO \
   -D WITH_OPENEXR=NO \
   -D WITH_TBB=NO \
   -D BUILD_EXAMPLES=NO \
   -D BUILD_ANDROID_EXAMPLES=NO \
   -D INSTALL_PYTHON_EXAMPLES=NO \
   -D BUILD_DOCS=NO \
   -D BUILD_opencv_python2=NO \
   -D BUILD_opencv_python3=ON \
   -D PYTHON3_EXECUTABLE=/usr/local/bin/python \
   -D PYTHON3_INCLUDE_DIR=/usr/local/include/python3.7m/ \
   -D PYTHON3_LIBRARY=/usr/local/lib/libpython3.so \
   -D PYTHON_LIBRARY=/usr/local/lib/libpython3.so \
   -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.7/site-packages/ \
   -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.7/site-packages/numpy/core/include/ \
    .. && \
    make VERBOSE=1 && \
    make && \
    make install && \
    rm -rf /opt/opencv-${OPENCV_VERSION}

# Install other apk dependencies. freetype is necessary for matploylib
RUN apk add --update --no-cache \
    freetype-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev
RUN pip install jupyterlab requests 
RUN pip install pillow lxml cssselect  
RUN pip install mapboxgl 
RUN pip install matplotlib pandas seaborn 
#RUN pip install tensorflow keras
#torch torchvision
#RUN jupyter nbextension enable --py widgetsnbextension
#RUN jupyter serverextension enable --py jupyterlab --sys-prefix

RUN mkdir /data

#ENV SHELL=/bin/zsh
#ENV SHELL=/bin/bash
#ENV PROMPT=>
ENV TOKEN=""
EXPOSE 8888
CMD jupyter lab /data --ip=0.0.0.0 --port=8888 --NotebookApp.token=$TOKEN --no-browser --allow-root
