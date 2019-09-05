from collections import namedtuple
from fractions import Fraction
import operator

# https://en.wikipedia.org/wiki/24_Game


Operator = namedtuple('Operator', ['f', 'rep'])
OPERATORS = [
    Operator(operator.add, '+'),
    Operator(operator.sub, '-'),
    Operator(operator.mul, '*'),
    Operator(Fraction, '/'),
]


class OperatorTerm(namedtuple('_OperatorTerm', ['op', 'terms'])):
    def eval(self):
        return self.op.f(*(term.eval() for term in self.terms))

    def __repr__(self):
        return f'OperatorTerm({self.op.rep}, {self.terms!r})'

    def pretty(self):
        return (
            '(' +
            self.terms[0].pretty() + ' ' +
            self.op.rep + ' ' +
            self.terms[1].pretty() +
            ')'
        )


class NumberTerm(namedtuple('_NumberTerm', ['n'])):
    def eval(self):
        return self.n

    def pretty(self):
        return str(self.n)


def has_match(*nums, total=24):
    terms = [ NumberTerm(n) for n in nums ]
    return any(c.eval() == total for c in gen_combinations(terms))


def combinations(*nums, total=24):
    terms = [ NumberTerm(n) for n in nums ]
    return [ c for c in gen_combinations(terms) if c.eval() == total ]


def gen_combinations(terms):
    if len(terms) == 1:
        yield terms[0]
    else:
        # brute force combine
        for taken, rest in gen_take(terms, 2):
            for op in OPERATORS:
                new_term = OperatorTerm(op, taken)
                try:
                    # verify that evaluation is possible before continuing
                    _ = new_term.eval()
                    yield from gen_combinations([new_term] + rest)
                except ZeroDivisionError:
                    pass


def gen_take(terms, count):
    for i in range(len(terms)):
        term = terms[i]
        rest = terms[:i] + terms[i + 1:]
        if count == 1:
            yield [term], rest
        else:
            for sub_terms, sub_rest in gen_take(rest, count - 1):
                yield [term] + sub_terms, sub_rest
