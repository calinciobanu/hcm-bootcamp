namespace: Integrations.demo.aos
flow:
  name: install_aos
  inputs:
    - username: "${get_sp('vm_username')}"
    - password:
        default: "${get_sp('vm_password')}"
        sensitive: true
    - tomcat_host: 10.0.46.104
    - account_service_host:
        default: 10.0.46.80
        required: false
    - db_host:
        default: 10.0.46.81
        required: false
  workflow:
    - install_postgres:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - script_url: "${get_sp('script_install_postgres')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: as_host_given
    - as_host_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(get('account_service_host', tomcat_host) != tomcat_host)}"
        navigate:
          - 'TRUE': install_java_1
          - 'FALSE': deploy_wars
    - install_java_1:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat_1
    - install_tomcat_1:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
    - deploy_wars:
        do:
          Integrations.demo.aos.sub_flows.deploy_wars:
            - tomcat_host: '${tomcat_host}'
            - account_service_host: "${get('account_service_host', tomcat_host)}"
            - db_host: "${get('db_host', tomcat_host)}"
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 134
        y: 181
      install_java:
        x: 435
        y: 161
      install_tomcat:
        x: 613
        y: 174
      as_host_given:
        x: 383
        y: 342
      install_java_1:
        x: 101
        y: 524
      install_tomcat_1:
        x: 384
        y: 500
      deploy_wars:
        x: 574
        y: 509
        navigate:
          0caba3a6-9b04-3256-544b-0b290114e1cc:
            targetId: dc6bdd67-4bb2-fcdd-4aa7-4d99d5f7e1de
            port: SUCCESS
          a8a42964-73ef-b2d1-7987-9d02a6406823:
            targetId: b0d729a4-66e4-c3b1-2009-fdb437afeb3a
            port: FAILURE
    results:
      SUCCESS:
        dc6bdd67-4bb2-fcdd-4aa7-4d99d5f7e1de:
          x: 666
          y: 410
      FAILURE:
        b0d729a4-66e4-c3b1-2009-fdb437afeb3a:
          x: 691
          y: 604
