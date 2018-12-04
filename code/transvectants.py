from sympy import symbols, Symbol, diff, simplify
from sympy.printing.latex import LatexPrinter, print_latex
from sympy.core.function import UndefinedFunction, Function

def tensor_product(funcs):
    n = len(funcs)
    x = symbols('x0:{}'.format(n))
    y = symbols('y0:{}'.format(n))
    Q = 1
    for i in range(n):
        Q *= funcs[i](x[i], y[i])
    return Q 

def omega_process(Q, i, j, n):
    x = symbols('x0:{}'.format(n))
    y = symbols('y0:{}'.format(n))
    return diff(Q, x[i], y[j]) - diff(Q, x[j], y[i])

def trace(Q, n):
    x = symbols('x0:{}'.format(n))
    y = symbols('y0:{}'.format(n))
    xx = Symbol('x')
    yy = Symbol('y')
    replacements = [(x[i], xx) for i in range(n)] + [(y[i], yy) for i in
            range(n)]
    return Q.subs(replacements)

def partial_transvectant(funcs, pairs):
    n = len(funcs)
    Q = tensor_product(funcs)
    for pair in pairs:
        Q = omega_process(Q, pair[0], pair[1], n)
    return simplify(trace(Q, n))
    
# The following code comes from the pretty pritn module documentation for
# Sympy
class MyLatexPrinter(LatexPrinter):
    """Print derivative of a function of symbols in a shorter form.
    """
    def _print_Derivative(self, expr):
        function, *vars = expr.args
        if not isinstance(type(function), UndefinedFunction) or \
           not all(isinstance(i, Symbol) for i in vars):
            return super()._print_Derivative(expr)

        # If you want the printer to work correctly for nested
        # expressions then use self._print() instead of str() or latex().
        # See the example of nested modulo below in the custom printing
        # method section.
        return "{}_{{{}}}".format(
            self._print(Symbol(function.func.__name__)),
                        ''.join(self._print(i) for i in vars))


def print_my_latex(expr):
    """ Most of the printers define their own wrappers for print().
    These wrappers usually take printer settings. Our printer does not have
    any settings.
    """
    print(MyLatexPrinter().doprint(expr))
