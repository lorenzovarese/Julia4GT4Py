# python_call.jl

# Import PyCall
using PyCall
using Revise # to clean the REPL

# Import a Python package (e.g., numpy)
# np = pyimport("numpy")

# # Execute something (e.g., create a numpy array and perform an operation)
# array = np.array([1, 2, 3, 4, 5])
# sum_array = np.sum(array)

# println("Sum of the array: $sum_array")

# Set a breakpoint in Python and inspect the surroundings
function breakpoint_demo()
    println("Entering Python code for debugging...")
    py"""
def test_function():
    array = [1, 2, 3, 4, 5]
    sum_array = sum(array)
    return sum_array

result = test_function()
print(f"Result: {result}")
"""
    println("Exited Python code.")
end

breakpoint_demo()

# Documentation obtained on code inspection of the py""" macro:

"""
    py".....python code....."

Evaluate the given Python code string in the main Python module.

If the string is a single line (no newlines), then the Python
expression is evaluated and the result is returned.
If the string is multiple lines (contains a newline), then the Python
code is compiled and evaluated in the `__main__` Python module
and nothing is returned.

If the `o` option is appended to the string, as in `py"..."o`, then the
return value is an unconverted `PyObject`; otherwise, it is
automatically converted to a native Julia type if possible.

Any `\$var` or `\$(expr)` expressions that appear in the Python code
(except in comments or string literals) are evaluated in Julia
and passed to Python via auto-generated global variables. This
allows you to "interpolate" Julia values into Python code.

Similarly, ny `\$\$var` or `\$\$(expr)` expressions in the Python code
are evaluated in Julia, converted to strings via `string`, and are
pasted into the Python code.   This allows you to evaluate code
where the code itself is generated by a Julia expression.
"""
#macro py_str(code, options...)

# Note in this case I obtain a PyDict m that conttains the result of the python function
# but actually the ret variable present in the local scope contains nothing because
# my python snippet of code is multiline
