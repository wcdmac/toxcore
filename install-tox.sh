#!/bin/bash
GIT_PATH="toxcore-git"
OUTPUT="toxcore"
DIRS=(
    "toxcore"
    "toxav"
    "toxencryptsave"
)
echo "Cloning JFreegman/toxcore ngc_merge branch (includes Group v2 API)"
rm -rf $GIT_PATH
git clone --depth 1 --branch ngc_merge https://github.com/JFreegman/toxcore.git $GIT_PATH
echo "Removing old toxcore directory"
rm -rf $OUTPUT
mkdir $OUTPUT
for dir in ${DIRS[@]}; do
    echo "Copying files from $GIT_PATH/$dir to $OUTPUT/$dir"
    cp -rv $GIT_PATH/$dir $OUTPUT
done
echo "Changing all .c files to .m files (making Xcode happy)"
for file in toxcore/**/*.c; do
    mv -v "$file" "${file%.c}.m"
done
remove_files_matching() {
    for file in $1; do
        echo "Removing $file"
        rm $file
    done
}
remove_files_matching "toxcore/**/*.bazel"
remove_files_matching "toxcore/**/*_test.cpp"
remove_files_matching "toxcore/**/*_test.cc"
remove_files_matching "toxcore/**/*_test.hh"
remove_files_matching "toxcore/**/*_fuzz_test.cc"
remove_files_matching "toxcore/**/*.api.h"
remove_files_matching "toxav/**/*.bazel"
remove_files_matching "toxav/**/*_test.cc"
remove_files_matching "toxencryptsave/**/*.bazel"
echo "Copying events directory"
if [ -d "$GIT_PATH/toxcore/events" ]; then
    mkdir -p $OUTPUT/toxcore/events
    cp -rv $GIT_PATH/toxcore/events/* $OUTPUT/toxcore/events/
    for file in $OUTPUT/toxcore/events/*.c; do
        mv -v "$file" "${file%.c}.m"
    done
fi
echo "Copying cmp library files directly into toxcore/toxcore/ for flat include"
if [ -d "$GIT_PATH/third_party/cmp" ]; then
    cp -v $GIT_PATH/third_party/cmp/cmp.h $OUTPUT/toxcore/toxcore/
    cp -v $GIT_PATH/third_party/cmp/cmp.c $OUTPUT/toxcore/toxcore/
    mv -v $OUTPUT/toxcore/toxcore/cmp.c $OUTPUT/toxcore/toxcore/cmp.m
fi
echo "Replacing header includes for CocoaPods compatibility"
find $OUTPUT -name "*.h" -o -name "*.m" | while read file; do
    sed -i '' 's/#include <opus.h>/#include "opus.h"/g' "$file" 2>/dev/null || true
    sed -i '' 's/#include <sodium.h>/#include "sodium.h"/g' "$file" 2>/dev/null || true
    sed -i '' 's/#include <vpx\/vpx_decoder.h>/#include "vpx\/vpx_decoder.h"/g' "$file" 2>/dev/null || true
    sed -i '' 's/#include <vpx\/vpx_encoder.h>/#include "vpx\/vpx_encoder.h"/g' "$file" 2>/dev/null || true
    sed -i '' 's/#include <cmp\/cmp.h>/#include "cmp.h"/g' "$file" 2>/dev/null || true
    sed -i '' 's/#include <cmp\/msgpack.h>/#include "msgpack.h"/g' "$file" 2>/dev/null || true
    sed -i '' "s/#include \"..\/third_party\/cmp\/cmp.h\"/#include \"cmp.h\"/g" "$file" 2>/dev/null || true
    sed -i '' "s/#include \"events\/events_alloc.h\"/#include \"toxcore\/events\/events_alloc.h\"/g" "$file" 2>/dev/null || true
done
echo "Done preparing toxcore with Group v2 support"
