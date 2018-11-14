namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.99
    - account_service_host: 10.0.46.99
    - db_host: 10.0.46.99
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password:
                  value: '${password}'
                  sensitive: true
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - script_url: "${get_sp('script_deploy_war')}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 255
        y: 255
      deploy_tm_wars:
        x: 487
        y: 255
        navigate:
          ea04c3f0-71c7-56d1-6b52-8142418cc9d0:
            targetId: eac58fbf-6366-d714-b770-f194448935d6
            port: SUCCESS
    results:
      SUCCESS:
        eac58fbf-6366-d714-b770-f194448935d6:
          x: 671
          y: 273
