# wiremockctl

> **Status:** in progress (implementation ongoing).

wiremockctl runs a local WireMock server in a Podman container to mock the APIs your service depends on, without you needing to know how WireMock works. You create mocks by answering questions, switch them on or off with one command, and keep everything in your project folder.

## Why

Developing against external APIs needs a stable stand-in. Setting up WireMock by hand means dealing with containers, mapping files, and its admin API. wiremockctl hides that behind a few simple commands.

## Requirements

- Bash
- Podman
- curl
- jq

Every command except `init` runs the [preflight checks](docs/preflight-checks.md) first. If one fails, it stops and tells you what is missing.

## Concept

The current folder is one WireMock server. Run `wiremockctl` in another folder to run another WireMock server.

```
my-project/
├── mappings/        # active mocks
├── __files/         # files used in responses
├── disabled/        # switched-off mocks
└── wiremockctl.env  # settings for this server
```

Run `wiremockctl init` to create this structure.

## Commands

| Command                      | What it does                                                                  | Workflow                               |
| ---------------------------- | ----------------------------------------------------------------------------- | -------------------------------------- |
| `wiremockctl init`           | Sets up the folder structure and settings file for a new mock server.         | [View](docs/command-init.md)           |
| `wiremockctl start`          | Starts the WireMock server in a Podman container and loads all active mocks.  | [View](docs/command-start.md)          |
| `wiremockctl stop`           | Stops the WireMock server and removes the Podman container.                   | [View](docs/command-stop.md)           |
| `wiremockctl list`           | Shows all mocks, active and disabled.                                         | [View](docs/command-list.md)           |
| `wiremockctl add`            | Guides you through creating a new mock and lets you review it in your editor. | [View](docs/command-add.md)            |
| `wiremockctl disable <file>` | Switches a mock off without deleting it.                                      | [View](docs/command-disable-enable.md) |
| `wiremockctl enable <file>`  | Switches a disabled mock back on.                                             | [View](docs/command-disable-enable.md) |

## Configuration

| Variable           | Default                       | Purpose                                                     |
| ------------------ | ----------------------------- | ----------------------------------------------------------- |
| `WIREMOCK_IMAGE`   | `docker.io/wiremock/wiremock` | Which WireMock image to use (pin a version here).           |
| `WIREMOCK_PORT`    | `8080`                        | Port the WireMock server listens on.                        |
| `WIREMOCK_TIMEOUT` | `30`                          | Seconds to wait for the WireMock server to get ready.       |
| `WIREMOCK_EDITOR`  | none                          | Editor used to edit a mock file (e.g. `nano`, `vim`, etc.). |

Two WireMock servers running at once need different ports.

Settings are read from `wiremockctl.env` in the current folder.

## Output

Colors are shown only in a terminal. To turn them off, run with `NO_COLOR=1`, for example `NO_COLOR=1 wiremockctl list`.

## How mocks are loaded

When the WireMock server starts, it loads the mocks one by one and checks them. If one is invalid, the server stops and tells you which file is wrong and why. The same applies when you turn a mock on (enable) or off (disable).

## What a mock can do

- Match a request by method, URL, query parameters, headers, and body.
- Return a status, headers, and a body.
- Delay the response.
- Take priority over other mocks.
- Simulate failures, such as a dropped connection or an empty response.

## Open topics

To test on the WireMock version in use:

- WireMock reports when it is ready.
- WireMock accepts valid mocks and rejects invalid ones with a clear message.
- WireMock may ignore misspelled fields, so some typos might not be caught (e.g., `statuss`).
- Reloading clears all mocks and resets scenario state.

## Notes

- Mocks loaded into the server live only in memory. The files on disk are the source of truth.
- Scenario (stateful mock) state is reset on every reload.

## License

[MIT](LICENSE) — free to use, modify, and distribute.
