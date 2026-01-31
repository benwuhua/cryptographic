#!/bin/bash
# cryptographic 编译脚本

export DEVECO_SDK_HOME="/Applications/DevEco-Studio.app/Contents/sdk"
export JAVA_HOME="/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:/Applications/DevEco-Studio.app/Contents/tools/node/bin:$PATH"

cd "$(dirname "$0")"

/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw assembleHap --mode=module -p product=default
