# Command: disable / enable

## disable \<file>

Switches a mock off without deleting it.

## enable \<file>

Switches a disabled mock back on.

## Workflow Overview

```mermaid
flowchart TD
  start(["START (disable or enable)"]) --> file_exists{"File exists?"}
  file_exists -- yes --> move_file["Move the file to the other folder"]
  file_exists -- no --> error1["Tell the user the file was not found"]
  error1 --> end1(["END: error"])

  move_file --> server_up{"Server running?"}
  server_up -- no --> end2(["END: success"])
  server_up -- yes --> reset_mocks["Clear the mocks on the server"]

  reset_mocks --> load["Take the next mock, in alphabetical order"]

  load --> process["Load it"]
  process --> success{"Accepted?"}
  success -- yes --> more{"More mocks?"}
  success -- no --> error2["Show the file name and the reason, then stop and remove the server"]
  error2 --> end3(["END: error"])

  more -- yes --> load
  more -- no --> done["Mocks reloaded"]
  done --> end4(["END: success"])
```

`disable` also works while the server is stopped, so that you can switch off an invalid mock after a failed start.
