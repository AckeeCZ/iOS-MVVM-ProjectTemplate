#!/bin/sh

cd "$PROJECT_DIR"
COMMITS=`git rev-list HEAD --count`

echo "// Auto-generated" > "$INFOPLIST_PREFIX_HEADER"
echo "" >> "$INFOPLIST_PREFIX_HEADER"
echo "#define ACK_BUILD_NUMBER $COMMITS" >> "$INFOPLIST_PREFIX_HEADER"
cd -
