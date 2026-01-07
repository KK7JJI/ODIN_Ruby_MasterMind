def generate_solution_set
  arr = Array.new(1296) \
    { Array.new(4) { 0 } }

  valid_vals = ('A'...('A'.ord + 6).chr).to_a

  arr = valid_vals.repeated_permutation(4).to_a
  p arr
  p arr.length
end

generate_solution_set
