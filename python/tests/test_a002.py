from algoplay.twentyfour import has_match


def test_twentyfour():
    assert has_match(5, 2, 7, 8)  # (5 * 2 - 7) * 8
    assert not has_match(1, 1, 1, 1)
