FROM ubuntu:18.04

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.0.8


# Install basic dependencies
RUN apt-get update && \
    apt-get install sudo curl -y 


SHELL ["/bin/bash", "-c"]

# Install msodbc
# Reference: https://docs.microsoft.com/pt-br/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
RUN sudo su && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    exit && \
    sudo apt-get install apt-transport-https && \
    sudo apt-get update && \
    sudo ACCEPT_EULA=Y apt-get install msodbcsql17 && \
    sudo ACCEPT_EULA=Y apt-get install mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \ 
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc && \
    sudo apt-get install unixodbc-dev -y


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
RUN pip install "poetry==$POETRY_VERSION"

