import unittest
import os
import glob
import abasc

class TestEmitter(unittest.TestCase):
  
    @classmethod
    def setUpClass(cls):
        testdir = os.path.dirname(__file__)
        cls.refdir = os.path.join(testdir, "refs")
        cls.outdir = os.path.join(testdir, "outputs")
        extensions = ["*.bin", "*.map", "*.lst", "*.asm"]
        for ext in extensions:
            removeexpr = os.path.join(cls.outdir, ext)
            for file in glob.glob(removeexpr): os.remove(file)

    def _compare_bins(self, infile, outfile):
        infile = os.path.join(self.refdir, infile)
        outfile = os.path.join(self.outdir, outfile)
        opts = abasc.AbascOptions(infile, outfile)
        opts.debug = True
        try:
            abasc.compile(opts)
        except Exception as e:
            self.fail("The compiling process was aborted " + str(e))
        try:
            infile = infile.replace(".bas", ".bin")
            with open(infile, "rb") as fd:
                refbin = fd.read()
            with open(outfile, "rb") as fd:
                newbin = fd.read()
        except Exception as e:
            self.fail("Error accesing to the binary files " + str(e))
        self.assertEqual(len(refbin), len(newbin), "binary lengths are different")
        for i in range(0, len(refbin)):
            self.assertEqual(refbin[i], newbin[i], "binary files content is different")

    def test_arrays(self):
        self._compare_bins("arrays.bas", "arrays.bin")

    def test_bomber(self):
        self._compare_bins("bombardero.bas", "bombardero.bin")

    def test_cast(self):
        self._compare_bins("cast.bas", "cast.bin")

    def test_chrs(self):
        self._compare_bins("chrs.bas", "chrs.bin")

    def test_colors(self):
        self._compare_bins("colors.bas", "colors.bin")

    def test_cpcrslib(self):
        self._compare_bins("cpcrslib.bas", "cpcrslib.bin")

    def test_cpctelera(self):
        self._compare_bins("cpctelera.bas", "cpctelera.bin")

    def test_data(self):
        self._compare_bins("data.bas", "data.bin")

    def test_diamons(self):
        self._compare_bins("diamons.bas", "diamons.bin")

    def test_draw(self):
        self._compare_bins("draw.bas", "draw.bin")

    def test_esgrima(self):
        self._compare_bins("esgrima.bas", "esgrima.bin")

    def test_fill(self):
        self._compare_bins("fill.bas", "fill.bin")

    def test_for(self):
        self._compare_bins("fill.bas", "fill.bin")

    def test_guante(self):
        self._compare_bins("guante.bas", "guante.bin")

    def test_hello(self):
        self._compare_bins("hello.bas", "hello.bin")

    def test_include(self):
        self._compare_bins("include.bas", "include.bin")

    def test_lineinput(self):
        self._compare_bins("lineinput.bas", "lineinput.bin")

    def test_print(self):
        self._compare_bins("print.bas", "print.bin")

    def test_real(self):
        self._compare_bins("real.bas", "real.bin")

    def test_rebotes(self):
        self._compare_bins("rebotes.bas", "rebotes.bin")

    def test_record(self):
        self._compare_bins("record.bas", "record.bin")

    def test_sprites(self):
        self._compare_bins("sprites.bas", "sprites.bin")

    def test_symbols(self):
        self._compare_bins("symbols.bas", "symbols.bin")

    def test_while(self):
        self._compare_bins("while.bas", "while.bin")

if __name__ == "__main__":
    unittest.main()
