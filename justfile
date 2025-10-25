# https://just.systems

# start Python HTTP server and open thesis presentation
serve:
  python -m http.server 8080 &
  xdg-open "http://localhost:8080/thesis.html"

# kill Python HTTP server
kill-server:
  #!/usr/bin/env bash
  pkill -f "python -m http.server" || echo "'python -m http.server' not running"

# generate SVGs from Graphviz files
diagrams:
  dot -Tsvg -O images/*.dot
