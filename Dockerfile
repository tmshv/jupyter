FROM continuumio/miniconda3

#RUN apt-get install -y gtk+2.0 pkg-config
#RUN apt-get install -y pandoc
#RUN apt-get install -y --force-yes texlive-xetex
RUN apt-get update && \
    apt-get install libgl1-mesa-glx -y

RUN conda update conda
RUN conda install -y jupyter
RUN conda install -y jupyterlab

RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter serverextension enable --py jupyterlab

RUN conda install -y -c conda-forge opencv
RUN conda install -y lxml pillow pandas matplotlib  

RUN apt-get install -y zsh

RUN mkdir /data

ENV SHELL=/bin/zsh
ENV PROMPT=>
ENV TOKEN=""
CMD jupyter lab /data --ip=0.0.0.0 --port=8888 --NotebookApp.token=$TOKEN --no-browser --allow-root
