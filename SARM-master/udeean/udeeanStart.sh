#! /bin/bash
cd /home/Udeean/udeean
source bin/activate
exec gunicorn -c gunicorn.py run:api
