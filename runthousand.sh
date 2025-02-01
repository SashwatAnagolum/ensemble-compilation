while ! bazel run tools:qe-opt -- --help >/dev/null; do
    echo "Build failed, retrying..."
done