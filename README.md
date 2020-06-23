# Python Devel
## Docker Enviroment For Python Development :whale:

![Docker Pulls](https://img.shields.io/docker/pulls/ronnyamarante/python-devel?style=flat-square)


### How to use this image

#### Create a `Dockerfile` in your Python app project
```Dockerfile
FROM ronnyamarante/python-devel:1.0.0

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN poetry install

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```


### License
View license information for [Python 3](https://docs.python.org/3/license.html).  
  
As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).