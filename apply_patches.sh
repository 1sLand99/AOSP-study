#!/bin/bash

# 定义 patch 文件和对应的路径
declare -A patches=(
    ["aosp_art.patch"]="art"
    ["aosp_framework_base.patch"]="frameworks/base"
    ["aosp_libcore.patch"]="libcore"
)

# 遍历每个 patch 文件并应用
for patch_file in "${!patches[@]}"; do
    target_path=${patches[$patch_file]}
    full_patch_path="./$patch_file"

    # 检查 patch 文件是否存在
    if [[ -f $full_patch_path ]]; then
        echo "Applying patch $patch_file to $target_path..."

        # 进入目标目录并应用 patch
        cd "$target_path" || exit
        patch -p1 < "../$patch_file"

        # 检查 patch 是否成功应用
        if [[ $? -eq 0 ]]; then
            echo "$patch_file applied successfully."
        else
            echo "Failed to apply $patch_file in $target_path."
            exit 1
        fi

        # 返回 AOSP 根目录
        cd - > /dev/null
    else
        echo "Patch file $patch_file not found. Skipping."
    fi
done

echo "All patches applied successfully."