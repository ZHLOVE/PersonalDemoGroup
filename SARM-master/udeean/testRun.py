import sys, os

path_of_current_file = os.path.abspath(__file__)

path_of_current_dir = os.path.split(path_of_current_file)[0]

_file_name = os.path.basename(__file__)

sys.path.insert(0, path_of_current_dir)

work_class = 'sync'

workers = 4

chdir = path_of_current_dir

worker_connections = 2000

timeout = 30

max_requests = 2000

gracefule_timeout = 30

loglevel = 'info'

reload = True
debug = True

bind = "0.0.0.0:8000"

# errorlog = '/home/mcree/Error.err'
# accesslog = '/home/mcree/Log.log'
