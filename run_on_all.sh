for file in tests/benchmarks/*; do
       echo "Testing '$file'"
       # Run the command for each file
       ./round_trip_test.sh "$file"
   done
