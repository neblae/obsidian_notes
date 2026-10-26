# pl.ai portable

A self-contained Haxall + pl.* extensions runtime. The only thing it needs on the
machine is **Java 26 or newer** (`java -version`); no Fantom, no build tools.

## Run it

| OS            | Command                 |
|---------------|-------------------------|
| Windows       | `launch.bat`            |
| Linux / macOS | `./launch.sh`           |

From inside this directory. With no arguments it creates a project called `pl`
(prompting for a superuser name, password and HTTP port) if it doesn't exist yet,
then starts it. Open <http://localhost:8080/> (or the port you chose) and log in.

```
launch [init|run|start] [project] [options]
```

| Command | What it does |
|---|---|
| `start` (default) | `init` if the project doesn't exist yet, then `run` |
| `setup` | Enable the pl.* libs in an existing project (see below) |
| `init` | Create a project and enable the pl.* libs. Options: `-headless`, `-suUser NAME`, `-suPass PASS`, `-httpPort N`, `-httpsDisable`. Without `-headless` it prompts; with it and no `-suPass` a password is generated and printed once. |
| `run` | Run an existing project. Options: `-noAuth` (auto-login as su on loopback, for local use), `-console` |

Projects live in `./projects/<name>` (a name containing a path separator is used as
a path). Set `JAVA_HOME` to pick a JVM and `JAVA_OPTS` for JVM flags, e.g.
`JAVA_OPTS=-Xmx4g`.

Examples:

```
launch.bat init demo -headless -suUser su -suPass changeme -httpPort 8090
launch.bat run demo -noAuth
./launch.sh start demo
```

## Enable the pl.* extensions

A new project boots with stock Haxall libs only. `init` and `start` therefore run
`setup.axon` for you right after creating a project, so the pl.* libs are already
enabled when you first log in. To do it later (or again) use `launch setup [project]`.
Set `PL_SKIP_SETUP=1` to skip the automatic step.

How it works: the launcher starts the project's server briefly with `-noAuth` (auth is
off for loopback connections only), waits for its HTTP port, POSTs `setup.axon` to
`/api/sys/eval`, then stops the server. On Windows that is `setup-libs.ps1`; on
Linux/macOS it is a function in `launch.sh` and needs `curl`. If it fails it prints why
and carries on - the project is still usable.

`setup.axon` has one expression per line, because the Shell takes one line at a time -
you can also paste the lines in by hand, in order. The launcher sends each line as its own
request. It does three things:

1. Enables `hx.point`, `hx.conn`, `hx.sql`, `hx.mqtt`, `hx.comps` (dependencies of the pl.*
   libs) plus every installed `pl.*` lib in one `libAdd` call, so order doesn't matter. It skips
   libs that are already enabled, and a newly built pl.* lib is picked up automatically.
2. Runs `bioinformaticsSetup()`, which creates (only if missing) the UniProtKB resolver
   (`@queue-fetchUniprot`, a queue that is its own worker), the GO, InterPro, Pfam and PDB
   resolvers that it feeds (`@queue-xref-go`, `-interpro`, `-pfam`, `-pdb`), an LLM model,
   `@model-hpg`, and a starter agent, `@agent-ProteinAgent`.
3. Runs `themeSeedDefault()`, which makes the dark UI theme the project's default. The launcher
   first copies `themes/pl-dark.css` (put there by `make.ps1`) to the project's
   `io/pl-dark.css` unless it is already there. `themeSeedDefault()` then creates the theme
   `@theme-plDark` (only if missing) with that file as its stylesheet, and activates it only if
   the project has no active theme. Only that one theme carries the stylesheet: a theme made
   on the Themes page starts without one, and switching to any other theme drops it. Edit
   `io/pl-dark.css` to restyle; it is never overwritten. Skipped (and it says so) if the file is
   not in `io/`, as in a Docker project.

Running it again is harmless: nothing that already exists is touched, so your edits survive.

### The UniProt queue and protein agent

Enqueue accessions and the queue fetches and stores them (it starts straight away and re-checks
every 30 seconds; needs internet access to `rest.uniprot.org`). Each accession becomes a
`UniProtEntry` (the whole UniProt record, `@uniprotkb-P69905`) and a `Protein` (`@P69905`)
that points at it through `dataRefs`:

```
xrefEnqueue("UniProtKB", ["P69905", "P68871"])
readAll(protein)
readAll(uniProtEntry)
bioReadProtein("P69905")
```

Each entry's cross-references into GO, InterPro and Pfam are followed automatically: a record is made
for each (`readAll(goTerm)`, `readAll(interProEntry)`, `readAll(pfamEntry)`), queued on that
database's own resolver and filled in a few seconds later, and the Protein's `dataRefs` points at
all of them. Those resolvers call `www.ebi.ac.uk` (QuickGO, InterPro), so they need internet access
too. **PDB is switched off**: one protein can have hundreds of structures (hemoglobin alpha has
355), each a record and a request. To follow them too, enable it and resolve the protein again:

```
commit(diff(readById(@queue-xref-pdb), {disabled: removeMarker()}))
xrefResolve("UniProtKB", ["P69905"])
```

`@agent-ProteinAgent` uses `@model-hpg` (UF's HPG endpoint, `gemma-4-31b-it`). The API key is a
secret and can't be shipped, so set yours before the agent can answer:

```
passwordSet(@model-hpg, "your-api-key")
```

To use a different model, create it in the UI and repoint the agent:

```
commit(diff(readById(@agent-ProteinAgent), {agentModel: @your-model-id}))
```

How UniProt is fetched is stored on the `@queue-fetchUniprot` rec itself (`fetch`, `extract` and
`work` are Axon source), so it can be edited there; setup never overwrites the rec. A project set up
before this version keeps working: setup turns its old queue into the resolver in place. It also
reports proteins stored in the old shape, and `bioMigrateProteins()` converts them.

Its tools are `bioReadProtein` (local database) and `bioFetchProtein` (straight from UniProt,
read-only) plus the standard skill and tool-loading tools.

## What is in here

| Path | Contents |
|---|---|
| `fantom/` | Fantom runtime: `lib/java/sys.jar`, `lib/fan/*.pod`, `etc/` |
| `haxall/` | Haxall pods, xetolibs, DuckDB JDBC jar; `fan.props` wires the search path |
| `plExts/` | the pl.* extension pods and xetolibs |
| `xeto/`, `haystack-defs/` | the `sys.*`/`ph.*` specs and defs Haxall loads |
| `themes/` | `pl-dark.css`, the default theme's stylesheet (copied into each new project's `io/`) |
| `projects/` | your databases (created on first use, never overwritten by a rebuild) |

This directory is generated: rebuild it and `portable.zip` with `make.ps1` from the
repo root. Edit only `launch.bat`, `launch.sh`, `setup-libs.ps1` and this README by hand.
