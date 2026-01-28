FROM python:3.10

LABEL description="GraphQL ReadyMade Web"

ARG TARGET_FOLDER=/opt/grmw
WORKDIR $TARGET_FOLDER/

RUN apt install curl git

RUN useradd grmw -m 
RUN chown grmw. $TARGET_FOLDER/
USER grmw

RUN python -m venv venv
RUN . venv/bin/activate
RUN pip3 install --user --upgrade pip --no-warn-script-location --disable-pip-version-check

ADD --chown=grmw:grmw core /opt/grmw/core
ADD --chown=grmw:grmw db /opt/grmw/db
ADD --chown=grmw:grmw static /opt/grmw/static
ADD --chown=grmw:grmw templates /opt/grmw/templates

COPY --chown=grmw:grmw app.py /opt/grmw
COPY --chown=grmw:grmw config.py /opt/grmw
COPY --chown=grmw:grmw setup.py /opt/grmw/
COPY --chown=grmw:grmw version.py /opt/grmw/
COPY --chown=grmw:grmw requirements.txt /opt/grmw/

RUN pip3 install -r requirements.txt --user --no-warn-script-location
RUN python setup.py

EXPOSE 5013/tcp
CMD ["python", "app.py"]
