class SpatialTransform2D:
    pass

class A2Transform(SpatialTransform2D):
    def __init__(self, a, b, c, d, tx, ty):
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.det = a*d - b*c;
        self.tx = tx
        self.ty = ty

    def forward_coords(self, x, y):
        xnew = self.a*x + self.b*y + self.tx
        ynew = self.c*x + self.d*y + self.ty
        return (xnew, ynew)

    def reverse_coords(self, x, y):
        xnew = 1/self.det*(self.d*(x - self.tx) - self.b*(y - self.ty))
        ynew = 1/self.det*(-self.c*(x - self.tx) + self.a*(y - self.ty))
        return (xnew, ynew)



