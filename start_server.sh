#!/bin/bash

python -m SimpleHTTPServer 8000 &
pid=$!

if [ $? == 0 ]; then
  echo -e "\nServer is successfully started. Open http://localhost:8000 in your browser to view the slides.\nTo kill the process, run \"kill -TERM ${pid}\"\n"
fi
