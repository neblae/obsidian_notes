#!/usr/bin/env bash
#
# launch.sh - init and/or run a pl.ai Haxall project from this directory.
# Works on Linux and macOS (bash 3.2+). Only needs Java on the machine.
#
#   ./launch.sh                         create project "pl" if missing, then run it
#   ./launch.sh init [project] [opts]   create a project (prompts for su user/password/port)
#   ./launch.sh run  [project] [opts]   run an existing project
#   ./launch.sh start [project] [opts]  init if missing, then run (the default)
#   ./launch.sh setup [project]         (re)enable the pl.* libs in a project
#   ./launch.sh help
#
# init/start also enable the pl.* libs right after creating a project (skip
# with PL_SKIP_SETUP=1); that step needs curl.
#
# init opts:  -headless -suUser <name> -suPass <pass> -httpPort <n> -httpsDisable
# run opts:   -noAuth (auto-login as su on loopback)  -console
#
# A bare project name lives in ./projects/<name>; a name containing a "/"
# is used as a path as-is. Set JAVA_HOME to pick a specific JVM, JAVA_OPTS
# for extra JVM flags (e.g. JAVA_OPTS=-Xmx4g).
#

# Minimum Java. make.ps1 rewrites this line to match the Fantom runtime that
# was packaged (the class-file version of fantom/lib/java/sys.jar).
MIN_JAVA=26

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

usage()
{
  awk 'NR > 2 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
}

die()
{
  echo "ERROR: $*" >&2
  exit 1
}

# hermetic: ignore any Fantom dev environment set up in this shell
unset FAN_HOME FAN_ENV FAN_ENV_PATH FAN_CP CLASSPATH

# ---- arguments -------------------------------------------------------------
CMD=start
case "$1" in
  init|run|start|setup) CMD="$1"; shift ;;
  help|-h|-help|--help|-\?) usage; exit 0 ;;
esac

PROJ=pl
case "$1" in
  ""|-*) ;;
  *) PROJ="$1"; shift ;;
esac

case "$PROJ" in
  */*) DB="$PROJ" ;;
  *)   DB="$HERE/projects/$PROJ" ;;
esac

# ---- sanity: is this directory complete? -----------------------------------
for f in fantom/lib/java/sys.jar fantom/lib/fan/sys.pod haxall/lib/fan/hx.pod \
         haxall/fan.props xeto/lib/xeto/sys.xetolib haystack-defs/lib/fan/ph.pod \
         plExts/lib/fan/plAgent.pod
do
  [ -e "$HERE/$f" ] || die "missing $f - this directory is incomplete; rebuild it with make.ps1"
done

# ---- java ------------------------------------------------------------------
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA="$(command -v java)"
fi
[ -n "$JAVA" ] || die "java not found. Install Java $MIN_JAVA or newer, or set JAVA_HOME."

JV="$("$JAVA" -version 2>&1)" || die "could not run '$JAVA -version'. Install Java $MIN_JAVA or newer, or set JAVA_HOME."
JVER="$(printf '%s\n' "$JV" | sed -n 's/.* version "\([^"]*\)".*/\1/p' | head -n 1)"
JMAJ="${JVER%%[.+_-]*}"
case "$JMAJ" in
  ""|*[!0-9]*) die "could not parse the Java version from: $(printf '%s\n' "$JV" | head -n 1)" ;;
esac
[ "$JMAJ" -ge "$MIN_JAVA" ] || die "Java $MIN_JAVA or newer is required, found $JVER ($JAVA). Set JAVA_HOME to a newer JDK/JRE."

# ---- hx --------------------------------------------------------------------
# Run from haxall/ - its fan.props (path=../haystack-defs;../xeto;../plExts)
# is what wires the whole runtime together.
hx()
{
  ( cd "$HERE/haxall" && exec "$JAVA" $JAVA_OPTS --enable-native-access=ALL-UNNAMED \
      -cp "$HERE/fantom/lib/java/sys.jar" "-Dfan.home=$HERE/fantom" \
      fanx.tools.Fan hx::Main "$@" )
}

exists()  { [ -f "$DB/db/folio.index" ]; }

# Enable the pl.* libs by running setup.axon against the project: start the
# server briefly with -noAuth (loopback only), POST setup.axon to /api/sys/eval,
# stop it. Never fails the launcher. Skip with PL_SKIP_SETUP=1.
setup_libs()
{
  [ -n "$PL_SKIP_SETUP" ] && return 0
  if [ ! -f "$HERE/setup.axon" ]; then
    echo "setup.axon not found - skipping pl.* library setup."; return 0
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "curl not found - skipping pl.* library setup. Paste setup.axon into the Shell instead."; return 0
  fi

  # The default theme's stylesheet (make.ps1 packages it as themes/pl-dark.css): give
  # the project a copy in io/ so setup.axon's themeSeedDefault() can point a Theme at
  # it. Never overwrites, so a project's own edits to it survive a re-run.
  if [ -f "$HERE/themes/pl-dark.css" ] && [ ! -f "$DB/io/pl-dark.css" ]; then
    mkdir -p "$DB/io" && cp "$HERE/themes/pl-dark.css" "$DB/io/pl-dark.css" ||
      echo "WARNING: could not copy the default theme stylesheet."
  fi

  local log body resp code port pid i expr ok
  log="$(mktemp "${TMPDIR:-/tmp}/plsetup.XXXXXX")"
  body="$log.body"; resp="$log.resp"
  echo "Enabling pl.* libs (starting the server briefly)..."

  # single subshell + exec so $! is the java process itself and kill reaches it
  ( cd "$HERE/haxall" && exec "$JAVA" $JAVA_OPTS --enable-native-access=ALL-UNNAMED \
      -cp "$HERE/fantom/lib/java/sys.jar" "-Dfan.home=$HERE/fantom" \
      fanx.tools.Fan hx::Main run "$DB" -noAuth ) >"$log" 2>&1 &
  pid=$!

  port=""
  i=0
  while [ $i -lt 240 ]; do
    port="$(sed -n 's/.*http started on port \([0-9][0-9]*\).*/\1/p' "$log" | head -n 1)"
    [ -n "$port" ] && break
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.5 2>/dev/null || sleep 1
    i=$((i + 1))
  done

  if [ -z "$port" ]; then
    echo "WARNING: the server did not report an HTTP port (is it already running, or the port in use?)."
    echo "         Skipping pl.* library setup - paste setup.axon into the Shell instead."
  else
    # each non-blank line of setup.axon is its own expression (a later line
    # may call a lib the earlier one enabled), so one request per line and
    # stop at the first failure
    ok=1
    while IFS= read -r expr || [ -n "$expr" ]; do
      expr="$(printf '%s' "$expr" | tr -d '\r')"
      [ -z "$(printf '%s' "$expr" | tr -d ' \t')" ] && continue
      expr="$(printf '%s' "$expr" | sed 's/\\/\\\\/g; s/"/\\"/g')"
      printf 'ver:"3.0"\nexpr\n"%s"\n' "$expr" > "$body"
      code="$(curl -sS -o "$resp" -w '%{http_code}' --max-time 300 \
                -H 'Content-Type: text/zinc; charset=utf-8' --data-binary "@$body" \
                "http://localhost:$port/api/sys/eval" 2>&1)"
      if [ "$code" != "200" ] || grep -q 'errType' "$resp" 2>/dev/null; then
        echo "WARNING: pl.* library setup failed (HTTP $code):"
        head -c 600 "$resp" 2>/dev/null; echo
        echo "Paste the lines of setup.axon into the Shell to retry."
        ok=0
        break
      fi
    done < "$HERE/setup.axon"
    [ $ok = 1 ] && echo "pl.* libs enabled."
  fi

  # stop the temporary server (TERM first so it shuts down cleanly)
  kill "$pid" 2>/dev/null
  i=0
  while kill -0 "$pid" 2>/dev/null && [ $i -lt 20 ]; do sleep 0.5 2>/dev/null || sleep 1; i=$((i + 1)); done
  kill -9 "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
  rm -f "$log" "$body" "$resp"
  return 0
}

do_init()
{
  mkdir -p "$(dirname "$DB")"
  hx init "$DB" "$@" || return $?
  setup_libs
}

do_setup()
{
  exists || die "project '$DB' does not exist - run: ./launch.sh init $PROJ"
  PL_SKIP_SETUP= setup_libs
}

do_run()
{
  exists || die "project '$DB' does not exist - run: ./launch.sh init $PROJ"
  echo
  echo "Starting $DB  (Ctrl+C to stop; default http://localhost:8080/)"
  echo
  hx run "$DB" "$@"
}

case "$CMD" in
  init)  do_init "$@" ;;
  run)   do_run "$@" ;;
  setup) do_setup ;;
  start)
    if ! exists; then
      echo "Project '$DB' does not exist - creating it."
      do_init || die "init failed"
      echo
      echo "Note the superuser credentials above, then the server starts."
    fi
    do_run "$@"
    ;;
esac
