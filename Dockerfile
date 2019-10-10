FROM continuumio/miniconda3

RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx 

RUN conda update conda

RUN conda install -y -c conda-forge opencv==4.1.0

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
