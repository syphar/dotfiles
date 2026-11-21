function mkpkg
  mkdir -p $argv[1]
  touch $argv[1]/__init__.py
end
