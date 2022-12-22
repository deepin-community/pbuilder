#/bin/bash

set -e

cd $(dirname $0)
for t in test_*; do
    ./"$t"
done
