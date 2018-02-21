FROM gitlab.wojciechkozlowski.eu:8443/wojtek/loki/runner-base

RUN apt install -y build-essential \
                   python \
                   python-pip

RUN pip install pycodestyle coverage mock
