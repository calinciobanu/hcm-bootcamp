namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host
    - username:
        sensitive: false
    - password:
        sensitive: true
    - url
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 196
        y: 316
      remote_secure_copy:
        x: 550
        y: 463
        navigate:
          0adf6a57-739b-c293-1249-79edbfc57f2a:
            targetId: 537948d6-77bf-7f42-22ba-9ff6b7164c79
            port: SUCCESS
      get_file:
        x: 396
        y: 575
    results:
      SUCCESS:
        537948d6-77bf-7f42-22ba-9ff6b7164c79:
          x: 530
          y: 211
