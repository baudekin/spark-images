# * *****************************************************************************
# *
# *  Pentaho Data Integration
# *
# *  Copyright (C) 2002-2020 by Hitachi Vantara : http://www.pentaho.com
# *
# *  *******************************************************************************
# *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# *  this file except in compliance with the License. You may obtain a copy of the
# *  License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# *  Unless required by applicable law or agreed to in writing, software
# *  distributed under the License is distributed on an "AS IS" BASIS,
# *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# *  See the License for the specific language governing permissions and
# *  limitations under the License.
# *
# * *****************************************************************************
ARG BASE_CONTAINER=baudekin/spark3.0.0_pybuild_3.7:v0.1.2
FROM $BASE_CONTAINER

# Setup Notebook User
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

# Get the dependances for Jupyter Notbooks
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    emacs \
    git \
    jed \
    libsm6 \
    libxext-dev \ 
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-fonts-extra \
    tzdata \
    unzip \
    nano \
    ffmpeg \
    dvipng \
    nodejs \
    npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown $NB_USER:$NB_GID $HOME && \
    chmod g+w /etc/passwd

USER $NB_UID
WORKDIR $HOME
ARG PYTHON_VERSION=default

# Setup work directory for backward-compatibility
RUN mkdir $HOME/work;chmod -R 777 $HOME

ENV PATH=$PATH:$HOME/.local/bin

RUN pip3 install --quiet notebook==6.0.3 && \
    pip3 install --quiet jupyterhub==1.1.0 && \
    pip3 install --quiet jupyterlab==2.0.1 && \
    pip3 install --quiet beautifulsoup4==4.8.*  && \
    pip3 install --quiet bokeh==1.4.*  && \
    pip3 install --quiet cloudpickle==1.3.*  && \
    pip3 install --quiet cython==0.29.*  && \
    pip3 install --quiet dask==2.11.*  && \
    pip3 install --quiet dill==0.3.*  && \
    pip3 install --quiet h5py==2.10.*  && \
    # HDF5
    pip3 install --quiet tables==3.6.1  && \
    pip3 install --quiet ipywidgets==7.5.*  && \
    pip3 install --quiet ipympl==0.5.*  && \
    pip3 install --quiet matplotlib==3.2.*  && \
    pip3 install --quiet numba==0.48.*  && \
    pip3 install --quiet numexpr==2.7.*  && \
    pip3 install --quiet pandas==1.0.*  && \
    pip3 install --quiet patsy==0.5.*  && \
    pip3 install --quiet protobuf==3.11.*  && \
    pip3 install --quiet scikit-image==0.16.*  && \
    pip3 install --quiet scikit-learn==0.22.*  && \
    pip3 install --quiet scipy==1.4.*  && \
    pip3 install --quiet seaborn==0.10.*  && \
    pip3 install --quiet sqlalchemy==1.3.*  && \
    pip3 install --quiet statsmodels==0.11.*  && \
    pip3 install --quiet sympy==1.5.*  && \
    pip3 install --quiet vincent==0.4.*  && \
    pip3 install --quiet widgetsnbextension==3.5.*  && \
    pip3 install --quiet xlrd

USER root

RUN jupyter notebook --generate-config && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build && \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build && \
    jupyter lab build && \
    jupyter lab clean 
RUN npm cache clean --force

USER $NB_UID

EXPOSE 8888

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Copy local files as late as possible to avoid cache busting
USER root
WORKDIR /usr/local/bin
RUN wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start.sh 
RUN wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start-singleuser.sh 
RUN wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start-notebook.sh 
RUN chmod 555 start.sh
RUN chmod 555 start-singleuser.sh
RUN chmod 555 start-notebook.sh

WORKDIR /usr/local/bin
RUN wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/jupyter_notebook_config.py
RUN chmod 555 jupyter_notebook_config.py 

WORKDIR $HOME

# Fix permissions on /etc/jupyter as root
USER root
RUN rm -r /$HOME/.cache && rm -rf /var/cache/apt/*
RUN find / -name jupyter
RUN chmod -R g+rwX $HOME/.local/etc/jupyter/
RUN chown $NB_USER:$NB_GID $HOME 

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
