"""
From project source directory:

python3 -m unittest test/test_opt.py
"""

import unittest
from basopt import BasOptimizer

class TestOptimize(unittest.TestCase):

    def test_peephole_ldhl_lda(self):
        source=(
    """
    ld      hl,251
    ld      a,l
    ld      bc,2              ; bytes to reserve
    call    rt_malloc         ; HL points to tmp memory
    ld      (hl),1
    inc     hl
    ld      (hl),a
    dec     hl
    """,
    """
    ld      a,251 & 0xFF
    ld      bc,2              ; bytes to reserve
    call    rt_malloc         ; HL points to tmp memory
    ld      (hl),1
    inc     hl
    ld      (hl),a
    dec     hl
    """)
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

    def test_peephole_ldhl_ldc_ldb(self):
        source=(
    """
    ld      hl,12
    ld      c,l               ; second color
    ld      b,l               ; first color
    push    bc
    call    &BC32             ; SCR_SET_INK
    """,
    """
    ld      c,12 & 0xFF
    ld      b,c
    push    bc
    call    &BC32             ; SCR_SET_INK
    """
    )
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

    def test_peephole_ldhl_ldb(self):
        source=(
    """
    ld      hl,4
    call    rt_mul16          ; HL = HL * DE
    push    hl                ; number of ticks to fire event
    ld      hl,1
    ld      b,l
    call    rt_timer_get      ; HL address to event block
    """,
    """
    ld      hl,4
    call    rt_mul16          ; HL = HL * DE
    push    hl                ; number of ticks to fire event
    ld      b,1 & 0xFF
    call    rt_timer_get      ; HL address to event block
    """)
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

    def test_peephole_ldhl_ldc(self):
        source=(
    """
    ld      hl,24
    push    hl
    ld      hl,12
    ld      c,l               ; second color
    pop     de
    """,
    """
    ld      hl,24
    push    hl
    ld      c,12 & 0xFF               ; second color
    pop     de
    """)
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

    def test_peephole_ldhl_pushhl_ldhl_popde(self):
        source=(
    """
    ld      hl,0
    push    hl
    ld      hl,(G_VAR_J)
    pop     de
    xor     a
    sbc     hl,de
    """,
    """
    ld      hl,0
    ex      de,hl
    ld      hl,(G_VAR_J)
    xor     a
    sbc     hl,de
    """)
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

    def test_peephole_multiple(self):
        source=(
    """
    ld      hl,0
    ld      c,l               ; second color
    ld      b,l               ; first color
    push    bc
    ld      hl,6
    ld      a,l
    pop     bc
    call    &BC32
    """,
    """
    ld      c,0 & 0xFF
    ld      b,c
    ld      a,6 & 0xFF
    call    &BC32
    """)
        optimizer = BasOptimizer()
        result = optimizer.optimize_peephole(source[0])
        self.assertEqual(source[1], result)

if __name__ == "__main__":
    unittest.main()
