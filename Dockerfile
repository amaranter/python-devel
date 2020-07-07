FROM ubuntu:18.04

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.0.8

SHELL ["/bin/bash", "-c"]


# Install basic dependencies
RUN apt-get update && \
    apt-get install sudo \
    curl \
    apt-utils -y 

# Install development dependencies
RUN apt-get install build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    wget \
    gnupg2 \
    libbz2-dev -y 


# Install Python
RUN wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz  && \
    mkdir -p /usr/src/python && \
    tar -xf Python-3.8.3.tgz -C /usr/src/python && \
    rm Python-3.8.3.tgz && \
    cd /usr/src/python/Python-3.8.3 && \
   ./configure --enable-optimizations && \
    make -j 4 && \
    sudo make install && \
    rm -rf /usr/src/python


# Install pip
RUN sudo apt install python3-pip -y

# Create Python some useful symlinks that are expected to exist
RUN cd /usr/local/bin && \
	  ln -s idle3 idle && \
    ln -s pydoc3 pydoc && \
    ln -s python3 python && \
    ln -s pip3 pip && \
    ln -s python3-config python-config


# Install Poetry packing and dependency manager
RUN pip install "poetry==$POETRY_VERSION" && \
    poetry config virtualenvs.create false


# Install msodbc
# Reference: https://docs.microsoft.com/pt-br/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
RUN sudo curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    sudo curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    sudo apt-get install apt-transport-https -y && \
    sudo apt-get update && \
    sudo ACCEPT_EULA=Y apt-get install msodbcsql17 -y && \
    sudo ACCEPT_EULA=Y apt-get install mssql-tools -y && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \ 
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc

# Install unixodbc-dev
RUN apt-get install unixodbc-dev -y


CMD ["/bin/bash"]