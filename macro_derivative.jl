
macro derivative(expr)
    # Reduce the code duplication here (after fixing the inner function for the advanced cases)
    expr_type = typeof(expr)
    if expr == :x
        return :(1)
    elseif expr_type <: Number # Fix the floating-point support
        return :(0)
    elseif expr_type == Expr
        function derive(e)
            if e == :x
                return :(1)
            elseif typeof(e) <: Number # Fix the floating-point support
                return :(0)
            # Linear combination x1 + x2
            elseif e.args[1] == :+
                return :($(derive(e.args[2])) + $(derive(e.args[3])))
            # Linear combination x1 - x2
            elseif e.args[1] == :-
                return :($(derive(e.args[2])) - $(derive(e.args[3])))
            # Case a*x
            elseif e.args[1] == :* && typeof(e.args[2]) == Int64 && e.args[3] == :x
                return e.args[2]
            # Case x^b
            elseif e.args[1] == :^ && e.args[2] == :x && typeof(e.args[3]) == Int64
                return :($(e.args[3]) * $(e.args[2]) ^ ($(e.args[3])-1))
            # Case a*x^b
            elseif e.args[1] == :* && typeof(e.args[2]) == Int64 && typeof(e.args[3])== Expr 
                power_expr = e.args[3]
                if power_expr.args[1] == :^ && power_expr.args[2] == :x && typeof(power_expr.args[3]) == Int64
                    exponent = :(power_expr.args[3])
                    return :(e.args[2]*(exponent)*:x^(exponent-1)) 
                end
            else 
                AssertionError("Cannot parse the expression")
            end
        end
        return derive(expr)
    else
        println("Invalid expression")
    end
end

expr_d_dx = @derivative 7
@assert expr_d_dx == :(0)

expr_d_dx = @derivative 2x
@assert expr_d_dx == :(2)

expr_d_dx = @derivative 2x + 3x
@assert expr_d_dx == :(2 + 3) # TODO: fix the aggregated results

expr_d_dx = @derivative 2x + 3
@assert expr_d_dx == :(2)

expr_d_dx = @derivative x^2
@assert expr_d_dx == :(2*x) # TODO: fix this case

# Handy methods
dump(:(x^2))
@macroexpand @derivative(x^2)

expr_d_dx = @derivative 2x^2
@assert expr_d_dx == :(2*x) # TODO: fix this case

expr_d_dx = @derivative :(x^2+x^3)
@assert expr_d_dx == :(2*x+3*x^2) # TODO: fix this case

# macroexpand(Main, @derivative 2x)