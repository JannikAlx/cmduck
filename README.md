# cmetalduck

The heaviest os of all time. Nachprogrammiert von Jannik Alexander als Teil des Betriebssystempraktikums der TH-Köln

# Table of Contents

- [Entwicklungsumgebung](#entwicklungsumgebung)
  * [Host OS](#host-os)
  * [Building the Cross Compiler](#building-the-cross-compiler)
    + [Binutils](#binutils)
    + [GCC](#gcc)



## Entwicklungsumgebung

Das eigentlich wichtigste ist das aufsetzen einer Entwicklungsumgebung. Deshalb wird im folgenden beschrieben wie meine aufgebaut ist.

### Host OS

Für die Entwicklung wird eine Ubuntu Distribution in der Virtualbox von Oracle verwendet.

- Kernel: 5.3.9-51-generic
- OS: Ubuntu 18.04.4 LTS bionic

Zuerst müssen alle Dependencies installiert werden, ansonsten kann man weder Binutils, noch GCC bauen.  In Ubuntu ist das relativ einfach, dank des packet managers. man braucht:

- GCC der mit dem Cross Compiler ersetzt wird
- G++ weil die Version von GCC über 4.8.0 ist
- Make zum verwenden der Makefiles
- Texinfo für Dokumentation bei Binutils
- GMP, MPFR und MPC sind alle dazu da, um mathematische Operationen mit kurzer Laufzeit ausführen zu können. Es erlaubt auch den einsatz von Floats, wobei die Präzision nur von der Menge an Speicher bestimmt wird.
- Außerdem: Flex, Bison, optional ClooG und ISL

Desweiteren müssen drei shell Variablen gesetzt werden. In diesem Fall wurden diese in ~/.bashrc als Befehle gespeichert, damit sie bei jedem shell Start auch gesetzt werden.

```bash
PREFIX="$HOME/opt/cross"
```

Das Prefix gibt den Pfad zu der Cross Compiler Umgebung an, sodass alle Files die mit dem Compiler zu tun haben in diesem Verzeichnis landen.

```bash
TARGET=i686-elf
```

Das Target ist ein genereisches Ziel für unseren Compiler, welches diesem eine Toolchain bereitstellt und den Vorteil hat, dass es einfacher für Einsteiger ist ein bootbares image zu erstellen.

```bash
PATH="$PREFIX/bin:$PATH"
```

Diese Variable sorgt dafür dass unser neues Verzeichnis auch in den Pfad mit aufgenommen wird, damit die erstellten ausführbahren Programme auch als solche erkannt werden.



### Building the Cross Compiler

Als nächstes wird der Cross Compiler von Source Code gebaut, welcher danach in der Lage ist ausführbaren Code für das Ziel i686-elf zu kompilieren. Man braucht einen Cross Compiler, weil der Compiler des Host OS sonst nur Code für das aktuelle System (x86_64-linux-gnu) erzeugen.

#### Binutils

Vorher bauen wir noch die sogenannten Binutils, diese enthalten viele Programmiertools, einige sind indirekt wichtig für den Bau des Cross Compilers. Wir benutzen vor allem:

- GNU Linker um Objekt Dateien(enthalten assembled code, also Maschinensprache) in den Kernel einzupflegen.
- GNU Assembler um Instruktionen wie mov o.ä in Maschinensprache umzuwandeln und daraus Objekt Dateien zu machen.

Nachdem der source code heruntergeladen ist, wird ein Makefile aufgerufen und danach die Regel install ausgeführt. Nach einiger Zeit sollten dann alle nötigen Tools installiert sein.

#### GCC

Danach kann man die GNU Compiler Collection (GCC) bauen. Auch hier wird ein Script zur Konfiguration des Makefiles ausgeführt. Danach kann man beispielsweise make all-gcc aufrufen um die Regel all-gcc aus dem Makefile auszuführen. Wir verwenden nicht make install, weil das unfertige OS noch nicht bereit für viele der Komponenten von GCC ist. Die Compiler Collection wird dazu benötigt die Sprachen C und C++ zu Kompilieren, also die Sprachen in der die abstrahierten Parts des Kernels nachher geschrieben werden.

### Check the version of the Compiler

Nun sollte man mit

```bash
~/opt/cross/bin/$TARGET-gcc --version
```

einen Output von dem neuen Cross Compiler bekommen. In diesem fall:

```bash
1686-elf-gcc (GCC) 11.0.0 20200504 (experimental)
```

Damit ist der Cross Compiler erfolgreich konfiguriert und man kann ihn verwenden. Wenn man allerdings versuchen würde normale C programme damit zu kompilieren würde er Fehler ausspucken weil der Compiler keine bzw nur ganz wenige Standardbibliotheken kennt.

Für Komfortabilität wurde noch der Path um das neue Verzeichnis erweitert.

```bash
export PATH="$HOME/opt/cross/bin:$PATH"
```

Jetzt kann man den Compiler mit $TARGET-gcc aufrufen.
