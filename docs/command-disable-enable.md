# Command: disable / enable

## disable \<prefix_file>

Switches off every mock whose file name starts with the prefix, without deleting them.

## enable \<prefix_file>

Switches back on every disabled mock whose file name starts with the prefix.

## Workflow Overview

```mermaid
flowchart TD
start(["START (disable or enable)"]) --> name_ok{"Prefix has at least 3 characters?"}
  name_ok -- yes --> file_exists{"Any file starts with the prefix?"}
  name_ok -- no --> error1["Tell the user the prefix is too short"]
  error1 --> end1(["END: error"])

  file_exists -- yes --> conflict{"Any match already in the other folder?"}
  file_exists -- no --> error2["Tell the user no file matches"]
  error2 --> end2(["END: error"])

  conflict -- no --> move_file["Move every matching file to the other folder"]
  conflict -- yes --> error3["Show the files in conflict"]
  error3 --> end3(["END: error"])

  move_file --> server_up{"Server running?"}
  server_up -- no --> end4(["END: success"])
  server_up -- yes --> reset_mocks["Clear the mocks on the server"]

  reset_mocks --> load["Take the next mock, in alphabetical order"]

  load --> process["Load it"]
  process --> success{"Accepted?"}
  success -- yes --> more{"More mocks?"}
  success -- no --> error4["Show the file name and the reason, then stop and remove the server"]
  error4 --> end5(["END: error"])

  more -- yes --> load
  more -- no --> done["Mocks reloaded"]
  done --> end6(["END: success"])
```

- The prefix ignores case and is matched as plain text, so `*` is not a wildcard.
- `disable` looks in the active mocks, and `enable` looks in the disabled mocks.
- Every matching file is moved. If any of them already exists in the other folder, nothing is moved.
- `disable` also works while the server is stopped, so that you can switch off invalid mocks after a failed start.
