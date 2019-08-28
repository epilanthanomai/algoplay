from algoplay.brackets import brackets_match


def test_brackets():
    assert brackets_match('')
    assert brackets_match('()')
    assert brackets_match('[]')
    assert brackets_match('{}')
    assert not brackets_match('(]')
    assert not brackets_match('([]{)')
    assert brackets_match('([]{([])})')
