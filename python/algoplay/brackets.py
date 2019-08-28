from enum import auto, Enum


def compile_brackets(pairs):
    """Precompile bracket pairs.

    Takes a list of open/close bracket pairs. The compiled dictionary maps
    each one to a bracket class (paren, square bracket, etc) represented
    here by the pair's open bracket, plus a bool representing whether it's
    an open bracket.
    """
    result = {}
    for (open_b, close_b) in pairs:
        result[open_b] = (open_b, True)
        result[close_b] = (open_b, False)
    return result


BRACKET_PAIRS = [
    '()',
    '[]',
    '{}',
]


BRACKETS = compile_brackets(BRACKET_PAIRS)


def brackets_match(s, pairs=None):
    """Test whether the brackets in the string match."""
    brackets = compile_brackets(pairs) if pairs else BRACKETS

    bracket_stack = []
    for c in s:
        this_b, is_open = brackets.get(c, (None, None))

        # If this isn't a recognized bracket, skip this char.
        if this_b is None:
            continue

        # If this is an open brakcet, push it onto the bracket stack.
        if is_open:
            bracket_stack.append(this_b)
            continue

        # Otherwise it's a close. If there are no open brackets on the
        # stack, then any close is unmatched.
        if not bracket_stack:
            return False

        # Pop a bracket off the stack. If it doesn't match, we're looking at
        # an unbalanced bracket.
        match_b = bracket_stack.pop()
        if match_b != this_b:
            return False

    # If we get to the end of the string and there are unmatched brackets,
    # they're unbalanced. If it's empty, they've all been matched and we're
    # balanced.
    return not bracket_stack
