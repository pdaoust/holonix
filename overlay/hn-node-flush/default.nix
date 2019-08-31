{ writeShellScriptBin }:

writeShellScriptBin "hn-node-flush" ''
  echo "flushing node artifacts"
  find . -wholename "**/node_modules" | xargs -I {} rm -rf {};
''
