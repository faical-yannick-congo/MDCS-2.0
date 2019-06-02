## MDCS web container
FROM mdcs-apps:1.0.1

## Arguments
ARG docker_admin
ARG mongodb_db
ARG mongodb_admin_username
ARG mongodb_admin_password
ARG mongodb_username
ARG mongodb_password
ARG mdcs_username
ARG mdcs_password
ARG mdcs_email

## Install Python dependencies
# RUN ${conda_path}/envs/mdcs/bin/pip install redis==3.2.0

## Install uwsgi
RUN ${conda_path}/envs/mdcs/bin/pip install uwsgi

## Install only for mongo shell
RUN sudo apt-get install -y mongodb

## Copy entrypoint script into the image
COPY . /home/${docker_admin}/web
RUN sudo chown ${docker_admin}:${docker_admin} /home/${docker_admin}/web -R

# Port to expose
EXPOSE 8000

ENV docker_admin ${docker_admin}
ENV mongodb_db ${mongodb_db}
ENV mongodb_admin_username ${mongodb_admin_username}
ENV mongodb_admin_password ${mongodb_admin_password}
ENV mongodb_username ${mongodb_username}
ENV mongodb_password ${mongodb_password}
ENV mdcs_username ${mdcs_username}
ENV mdcs_password ${mdcs_password}
ENV mdcs_email ${mdcs_email}

## Executing the services.
CMD cd web ; bash setup.sh
