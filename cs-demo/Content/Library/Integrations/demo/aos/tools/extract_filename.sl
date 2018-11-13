########################################################################################################################
#!!
#! @description: Extracts filename from url
#!
#! @input url: The URL to extract the filename from (substring after the last '/' character)
#!
#! @output filename: The extracted filename
#!
#! @result SUCCESS: Operation completed successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.demo.aos.tools

operation:
  name: extract_filename

  inputs:
    - url

  python_action:
    script: |
      filename = url[url.rfind("/")+1:]

  outputs:
    - filename: ${filename}

  results:
    - SUCCESS