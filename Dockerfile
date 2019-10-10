FROM continuumio/miniconda3

#RUN apt-get install -y gtk+2.0 pkg-config
#RUN apt-get install -y pandoc
#RUN apt-get install -y --force-yes texlive-xetex
RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx 

RUN conda update conda

# RUN conda install numpy pandas matplotlib seaborn 
# Install opencv 4+
RUN conda install -y -c conda-forge opencv==4.1.0

# Install+Setup jupyter
#RUN conda install -y jupyter
#RUN conda install -y -c conda-forge jupyterlab
# Install additional packages
#RUN conda install -y numpy pandas matplotlib seaborn plotly
RUN pip install jupyterlab
RUN pip install numpy pandas matplotlib seaborn mapboxgl lxml cssselect pillow  
RUN pip install tensorflow keras
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
