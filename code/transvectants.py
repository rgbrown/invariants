from sympy import symbols, Symbol, diff, simplify
from sympy.printing.latex import LatexPrinter, print_latex
from sympy.core.function import UndefinedFunction, Function

def tensor_product(funcs):
    n = len(funcs)
    x = Symbol('x')
    y = Symbol('y')
    xa = symbols('x0:{}'.format(n))
    ya = symbols('y0:{}'.format(n))
    Q = 1
    for i in range(n):
        Q *= funcs[i].subs([[x, xa[i]], [y, ya[i]]])
    return Q 

def omega_process(Q, i, j, n):
    xa = symbols('x0:{}'.format(n))
    ya = symbols('y0:{}'.format(n))
    return diff(Q, xa[i], ya[j]) - diff(Q, xa[j], ya[i])

def trace(Q, n):
    xa = symbols('x0:{}'.format(n))
    ya = symbols('y0:{}'.format(n))
    x = Symbol('x')
    y = Symbol('y')
    replacements = [(xa[i], x) for i in range(n)] + [(ya[i], y) for i in
            range(n)]
    return Q.subs(replacements)

def transvectant(f, g, r):
    Q = tensor_product((f, g))
    for k in range(r):
        Q = omega_process(Q, 0, 1, 2)
    return simplify(trace(Q, 2))

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
        if (not isinstance(type(function), UndefinedFunction) or 
            not all(isinstance(i[0], Symbol) for i in vars)):
            return super()._print_Derivative(expr)

        # If you want the printer to work correctly for nested
        # expressions then use self._print() instead of str() or latex().
        # See the example of nested modulo below in the custom printing
        # method section.
        print('boob')
        return "{}_{{{}}}".format(
            self._print(Symbol(function.func.__name__)),
                        ''.join(self._print(i) for i in vars))


def print_my_latex(expr):
    """ Most of the printers define their own wrappers for print().
    These wrappers usually take printer settings. Our printer does not have
    any settings.
    """
    print(MyLatexPrinter().doprint(expr))
    
def my_latex(expr):
    return MyLatexPrinter().doprint(expr)
