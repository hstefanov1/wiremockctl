# Command: add

Guides you through creating a new mock and lets you review it in your editor.

## Workflow Overview

```mermaid
flowchart TD
  start(["START"]) --> user_questions["Ask questions about the mock"]
  user_questions --> create_mock["Create the mock file"]
  create_mock --> edit_mock["Open it in the editor"]
  edit_mock --> wait_user{"User returns?"}

  wait_user -- yes --> validate_json{"File is well formed?"}
  wait_user -- aborted --> error1["User aborted, file stays in mappings"]
  error1 --> end1(["END: error"])

  validate_json -- no --> edit_mock
  validate_json -- yes --> server_up{"Server running?"}

  server_up -- yes --> send_mock["Send the mock to the server"]
  server_up -- no --> mock_saved["Mock saved and initialized at next start"]
  mock_saved --> end2(["END: success"])

  send_mock --> success{"Accepted?"}

  success -- yes --> mock_live["Mock is live"]
  success -- no --> error2["Show the reason"]
  error2 --> edit_mock

  mock_live --> end3(["END: success"])
```

- The file is created directly in the active mocks folder. If you abort, it stays there. The next start or reload will fail on it, and you can fix it, disable it, or delete it manually.
- With the server running, it loads only the new mock. The other mocks are not touched.
- With the server stopped, it checks only the file format. The full check happens at the next start.
