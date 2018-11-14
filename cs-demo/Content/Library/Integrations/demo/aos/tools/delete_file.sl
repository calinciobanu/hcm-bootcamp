namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host
    - username
    - password:
        sensitive: true
    - filename
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 163
        y: 304
        navigate:
          c556bd48-707f-6755-fac3-878123fbf999:
            targetId: 30f7e755-aa2e-8237-0739-fa7d93606b61
            port: SUCCESS
    results:
      SUCCESS:
        30f7e755-aa2e-8237-0739-fa7d93606b61:
          x: 422
          y: 198
