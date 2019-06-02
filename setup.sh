#!/bin/bash

# Setup mongdb
echo "=> Creating the admin user in MongoDB"
echo 'use admin
db.createUser( { user: "'${mongodb_admin_username}'", pwd: "'${mongodb_admin_password}'", roles: [ { role: "userAdminAnyDatabase", db: "admin"},"backup","restore"] } )
exit' | mongo -p admin --authenticationDatabase admin --host mongo --port 27017

echo "=> Creating the mgi user in MongoDB"
echo 'use '${mongodb_db}'
db.createUser( { user: "'${mongodb_username}'", pwd: "'${mongodb_password}'", roles: [ "readWrite" ] } )
exit' | mongo -p admin --authenticationDatabase admin --host mongo --port 27017

# Launch celery
${conda_path}/envs/mdcs/bin/celery -A mdcs worker -l info -Ofair --purge --detach

# Setup & Launch mdcs
${conda_path}/envs/mdcs/bin/python manage.py migrate auth
${conda_path}/envs/mdcs/bin/python manage.py migrate
${conda_path}/envs/mdcs/bin/python manage.py collectstatic --noinput

${conda_path}/envs/mdcs/bin/python manage.py compilemessages

echo 'from django.contrib.auth.models import User; User.objects.create_superuser("'${mdcs_username}'", "'${mdcs_email}'", "'${mdcs_password}'")' | ${conda_path}/envs/mdcs/bin/python manage.py shell

${conda_path}/envs/mdcs/bin/python manage.py runserver 0.0.0.0:8000
