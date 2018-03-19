#!/bin/bash

python_version=`python -c "import sys;t='{v[0]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`


case $python_version in
  2) python -m SimpleHTTPServer 8000 & ;;
  3) python -m http.server 8000 & ;;
  *) echo "Problem determining the python version. Exiting..." ; exit 1 ;;
esac

pid=$!

if [ $? == 0 ]; then
  echo -e "\nServer is successfully started. Open http://localhost:8000 in your browser to view the slides.\nTo kill the process, run \"kill -TERM ${pid}\"\n"
fi
