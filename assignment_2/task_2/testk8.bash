#!/bin/bash
chmod +x bash_tests/components_test.bash
chmod +x bash_tests/self_healing_test.bash
chmod +x bash_tests/traffic_ratio_test.bash

### Components TESTS ###
bash ./bash_tests/components_test.bash


### TRAFFIC TESTS ###
bash ./bash_tests/traffic_ratio_test.bash

### SELF HEALING TESTS ###
bash ./bash_tests/self_healing_test.bash

