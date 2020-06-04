FROM ubuntu:20.04 

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Setup timezone. Some packages wont work without it
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    python3-dev \
    python3-pip \
    git \
    curl \
    python3-opencv

RUN pip3 --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

RUN pip3 install tensorflow

#COPY bashrc /etc/bash.bashrc
#RUN chmod a+rwx /etc/bash.bashrc

RUN pip3 install jupyterlab numpy pandas matplotlib seaborn
RUN pip3 install lxml cssselect 
RUN pip3 install pillow 
RUN pip3 install mapboxgl geocoder 
#RUN pip3 install jupyter_http_over_ws
#RUN jupyter serverextension enable --py jupyter_http_over_ws

WORKDIR /data
ENV TOKEN=""
EXPOSE 8888

RUN python3 -m ipykernel.kernelspec

#CMD ["bash", "-c", "jupyter lab --notebook-dir=/data --ip 0.0.0.0 --no-browser --allow-root"]

#RUN apt-get update && \
#    apt-get install -y libgl1-mesa-glx 

#RUN conda install -y -c conda-forge opencv==4.1.0

#RUN mkdir /data

#ENV SHELL=/bin/zsh
#ENV SHELL=/bin/bash
#ENV PROMPT=>
#EXPOSE 8888
CMD jupyter lab /data --ip=0.0.0.0 --port=8888 --NotebookApp.token=$TOKEN --no-browser --allow-root

