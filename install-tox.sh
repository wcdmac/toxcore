#!/bin/bash
GIT_PATH="toxcore-git"
OUTPUT="toxcore"
CTOXCORE_VERSION="v0.2.20"
DIRS=(
    "toxcore"
    "toxav"
    "toxencryptsave"
)
echo "Cloning c-toxcore $CTOXCORE_VERSION"
rm -rf $GIT_PATH
git clone --depth 1 --branch $CTOXCORE_VERSION https://github.com/TokTok/c-toxcore.git $GIT_PATH
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
echo "Applying install-tox.patch"
git apply install-tox.patch