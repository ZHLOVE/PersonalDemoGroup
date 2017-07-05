# -*- coding:utf-8 -*-
def gcs(a,b,c=1):
    if 0==a%2 and 0==b%2:
        return gcs(a/2,b/2,c*2);

    s = abs(a-b)
    m = min(a,b)
    if s == m:
        return m*c
    return gcs(s,m,c)


class Rational(object):
    def __init__(self, p, q):
        self.p = p
        self.q = q

    def __add__(self, r):
        return Rational(self.p * r.q + self.q * r.p, self.q * r.q)

    def __sub__(self, r):
        return Rational(self.p * r.q - self.q * r.p, self.q * r.q)

    def __mul__(self, r):
        return Rational(self.p * r.p, self.q * r.q)

    def __div__(self, r):
        return Rational(self.p * r.q , self.q * r.p)

    def __str__(self):
        c = gcs(self.p, self.q)
        return '%s/%s' % (self.p/c, self.q/c)

    __repr__ = __str__

r1 = Rational(1, 2)
r2 = Rational(1, 4)
print r1 + r2
print r1 - r2
print r1 * r2
print r1 / r2
