namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host
    - username
    - password:
        sensitive: true
    - artifact_url:
        required: false
    - script_url
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - timeout: '300000'
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: has_failed
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 323
        y: 47
      copy_script:
        x: 452
        y: 239
      copy_artifact:
        x: 77
        y: 243
      execute_script:
        x: 75
        y: 449
        navigate:
          3b8a5a0b-15ea-4354-d06c-24b217799fdf:
            vertices:
              - x: 290.5
                y: 475.5
              - x: 424
                y: 478
            targetId: delete_script
            port: FAILURE
      delete_script:
        x: 442
        y: 414
      has_failed:
        x: 652
        y: 370
        navigate:
          253e134a-820d-2645-8f0f-022ddd0082a8:
            targetId: 597a7432-9d8b-fe1a-7e51-1d22ae0fbcc9
            port: 'TRUE'
          208186e9-693b-0d2c-9128-21256098d482:
            targetId: c0a3e0ce-5ea8-c6d6-7c8a-a7147f7e596f
            port: 'FALSE'
    results:
      FAILURE:
        c0a3e0ce-5ea8-c6d6-7c8a-a7147f7e596f:
          x: 769
          y: 543
      SUCCESS:
        597a7432-9d8b-fe1a-7e51-1d22ae0fbcc9:
          x: 790
          y: 373
