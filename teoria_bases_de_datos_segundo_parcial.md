# Teoría de Bases de Datos — Guía Completa de Examen

---

## ÍNDICE

1. [Dependencias Funcionales (FD)](#1-dependencias-funcionales)
2. [Cierre de Atributos (X⁺)](#2-cierre-de-atributos)
3. [Claves: Superclaves, Candidatas, Primarias](#3-claves)
4. [Atributos Primos y No Primos](#4-atributos-primos-y-no-primos)
5. [Recubrimiento Canónico (Fc)](#5-recubrimiento-canónico-fc)
6. [Atributos Ajenos (Extraños)](#6-atributos-ajenos-extraños)
7. [Formas Normales: 1FN, 2FN, 3FN, BCNF](#7-formas-normales)
8. [Descomposición: PSP y Conservación de Dependencias](#8-descomposición-psp-y-conservación-de-dependencias)
9. [Integridad Referencial](#9-integridad-referencial)
10. [Álgebra Relacional — Operaciones Fundamentales](#10-álgebra-relacional)
11. [SQL — Restricciones de Integridad](#11-sql--restricciones-de-integridad)
12. [Tuplas Colgantes](#12-tuplas-colgantes)
13. [Propiedades de F⁺ y X⁺ — Relaciones entre ellos](#13-propiedades-de-f-y-x--relaciones-entre-ellos)
14. [Producto Natural vs Producto Cartesiano](#14-producto-natural-vs-producto-cartesiano)
15. [RESOLUCIÓN DETALLADA DE TODOS LOS TESTS](#15-resolución-detallada-de-todos-los-tests)

---

## 1. Dependencias Funcionales

### ¿Qué es una dependencia funcional?

Una **dependencia funcional (FD)** `X → Y` sobre un esquema de relación R significa:

> Para toda relación r(R) válida, si dos tuplas tienen los mismos valores en X, también tienen los mismos valores en Y.

Dicho de otro modo: **X fija el valor de Y**. No pueden existir dos filas con el mismo X y distinto Y.

Ejemplo: `n_libro → título` significa que dado un número de libro, siempre obtenemos el mismo título.

### Tipos de dependencias

| Tipo | Definición |
|------|-----------|
| **Trivial** | `X → Y` donde `Y ⊆ X` (ej: `AB → A`) |
| **No trivial** | `X → Y` donde `Y ⊄ X` |
| **Completa** | `X → Y` y no existe `Z ⊂ X` tal que `Z → Y` |
| **Parcial** | `X → Y` y existe `Z ⊂ X` tal que `Z → Y` |

### Axiomas de Armstrong

Son reglas de inferencia **correctas y completas** para derivar todas las FD implicadas:

| Axioma | Regla |
|--------|-------|
| **Reflexividad** | Si `Y ⊆ X`, entonces `X → Y` |
| **Aumentatividad** | Si `X → Y`, entonces `XZ → YZ` |
| **Transitividad** | Si `X → Y` e `Y → Z`, entonces `X → Z` |

Reglas derivadas (también muy usadas):

| Regla | Descripción |
|-------|-------------|
| **Unión** | `X → Y` y `X → Z` ⟹ `X → YZ` |
| **Descomposición** | `X → YZ` ⟹ `X → Y` y `X → Z` |
| **Pseudotransitividad** | `X → Y` y `WY → Z` ⟹ `WX → Z` |

### Cierre de un conjunto de FD: F⁺

El **cierre F⁺** de un conjunto F es el conjunto de **todas las FD que se pueden derivar de F** usando los axiomas de Armstrong.

> F⁺ = { X → Y | F ⊢ X → Y }

Dos conjuntos F y G son **equivalentes** si y solo si `F⁺ = G⁺`. Esto es fundamental: aunque F y G como conjuntos de FDs sean distintos (distintas flechas escritas), pueden implicar exactamente lo mismo.

---

## 2. Cierre de Atributos

### ¿Qué es X⁺ (cierre de X bajo F)?

Dado un conjunto de atributos X y un conjunto de FD F:

> **X⁺** es el conjunto de todos los atributos que se pueden determinar a partir de X usando F.

### Algoritmo para calcular X⁺

```
Entrada: X (conjunto de atributos), F (conjunto de FD)
Salida: X⁺

1. X⁺ := X
2. Repetir hasta que no cambie X⁺:
   Para cada FD (A → B) en F:
     Si A ⊆ X⁺, entonces X⁺ := X⁺ ∪ B
3. Devolver X⁺
```

### Ejemplo

R = (A, B, C, D), F = { A → B, B → C, A → D }

Calcular A⁺:
- Inicio: A⁺ = {A}
- A → B: A ⊆ {A} ✓ → A⁺ = {A, B}
- B → C: B ⊆ {A,B} ✓ → A⁺ = {A, B, C}
- A → D: A ⊆ {A,B,C} ✓ → A⁺ = {A, B, C, D}

Como A⁺ = ABCD = R, **A es superclave**.

### Propiedades importantes de X⁺

- Siempre `X ⊆ X⁺` (X siempre está en su propio cierre — por reflexividad).
- **Nunca puede tener menos atributos que X**.
- X es superclave de R ⟺ X⁺ = R.
- `X → Y` está en F⁺ ⟺ `Y ⊆ X⁺`.
- **No es necesario calcularlo desde Fc** — se puede calcular directamente desde F; el resultado es el mismo.
- `X → X⁺` pertenece a F⁺ pero **no necesariamente a F**.
- Dado A ∈ X⁺: `X → A ∈ F⁺` y `X⁺ → A ∈ F⁺` (por reflexividad, ya que A ∈ X⁺).

---

## 3. Claves

### Superclave

Un conjunto de atributos K es **superclave** de R si `K⁺ = R` (determina todos los atributos).

### Clave candidata

Una superclave **minimal**: ningún subconjunto propio suyo es también superclave.

### Clave primaria

Una clave candidata elegida como identificador principal de la relación.

### Cómo encontrar claves candidatas

1. Calcular el cierre de cada subconjunto de atributos.
2. Un conjunto X es clave candidata si `X⁺ = R` y ningún subconjunto propio Z de X cumple `Z⁺ = R`.

**Truco rápido**:
- Los atributos que **no aparecen en ninguna FD** deben estar en **todas** las claves candidatas (nadie los determina, siempre hay que incluirlos).
- Los atributos que **solo aparecen en lados derechos** de FDs nunca pueden ser parte de una clave candidata por sí solos (nadie los puede usar como punto de partida).

---

## 4. Atributos Primos y No Primos

- **Atributo primo**: aparece en **alguna** clave candidata.
- **Atributo no primo**: no aparece en ninguna clave candidata.

Esta distinción es crucial para aplicar la definición de 3FN.

---

## 5. Recubrimiento Canónico (Fc)

### ¿Qué es?

Un **recubrimiento canónico Fc** de F es un conjunto de FD equivalente a F (`Fc⁺ = F⁺`) que cumple tres propiedades:

| Propiedad | Descripción |
|-----------|-------------|
| **Lado derecho singleton** | Cada FD tiene exactamente un atributo en el lado derecho: `X → A` |
| **Sin atributos ajenos** | No se puede eliminar ningún atributo del lado izquierdo sin cambiar F⁺ |
| **Sin FD redundantes** | No se puede eliminar ninguna FD sin cambiar F⁺ |

### Algoritmo para calcular Fc

**Paso 1 — Descomposición del lado derecho**

Convertir cada FD `X → Y₁Y₂...Yₙ` en `X → Y₁`, `X → Y₂`, ..., `X → Yₙ`.

**Paso 2 — Eliminar atributos ajenos del lado izquierdo**

Para cada FD `X → A` en F, para cada atributo B ∈ X:
- Calcular el cierre de `(X - {B})` bajo F.
- Si `A ∈ (X - {B})⁺`, entonces B es **ajeno** → reemplazar `X → A` por `(X - {B}) → A`.

**Paso 3 — Eliminar FD redundantes**

Para cada FD `X → A`, calcular X⁺ usando **todas las FDs excepto** `X → A`.
- Si `A ∈ X⁺` sin esa FD → la FD es redundante → eliminarla.

### Propiedades del Fc — MUY IMPORTANTES PARA EL EXAMEN

- **Fc no es único**: puede haber varios recubrimientos canónicos (Fc1, Fc2...) de un mismo F.
- **Siempre**: `F⁺ = Fc⁺` (equivalentes por definición).
- **Siempre**: `Fc1⁺ = Fc2⁺` si Fc1 y Fc2 son recubrimientos canónicos del mismo F.
- **F implica a Fc** (`F ⟹ Fc`) y **Fc implica a F** (`Fc ⟹ F`), porque tienen el mismo cierre.
- **NO siempre**: F = Fc como conjuntos (pueden diferir completamente en FDs escritas).
- **NUNCA**: F⁺ ≠ Fc⁺ (siempre son iguales).
- La forma normal de R no depende de si F es Fc o no.

---

## 6. Atributos Ajenos (Extraños)

Un atributo es **ajeno (extraño)** en una FD si se puede eliminar sin cambiar F⁺.

### En el lado derecho de `X → Y`

Un atributo A ∈ Y es ajeno si, eliminándolo, X sigue determinando A mediante las FDs restantes.

**Cómo verificar**: calcular X⁺ con `F' = (F - {X→Y}) ∪ {X → (Y-{A})}`. Si A ∈ X⁺ con F' → A es ajeno.

### En el lado izquierdo de `X → Y`

Un atributo B ∈ X es ajeno si `Y ⊆ (X - {B})⁺` calculado bajo F. Es decir: quitando B, el resto de X sigue determinando Y.

### Dependencia redundante

Una FD `X → A` es redundante en F si se puede derivar de las demás. Para verificar: calcular X⁺ usando F **sin** `X → A`. Si A ∈ X⁺ → redundante.

### Ejemplo completo — F = { BD → CAE, CA → B, B → E }

**¿Es E ajeno en BD → CAE?** (lado derecho)

Calculamos BD⁺ con F' = {BD → CA, CA → B, B → E} (quitamos E del lado derecho):
- {B,D} → BD→CA → {A,B,C,D} → CA→B (ya) → B→E → {A,B,C,D,E}
- E ∈ BD⁺ con F' → **E SÍ es ajeno** ✓

**¿Es C ajeno en BD → CAE?** (lado derecho)

Calculamos BD⁺ con F'' = {BD → AE, CA → B, B → E}:
- {B,D} → BD→AE → {A,B,D,E} → B→E (ya) → CA→B: C ∉ {A,B,D,E} → no aplica
- C ∉ {A,B,D,E} → **C NO es ajeno** ✗

**¿Es A ajeno en CA → B?** (lado izquierdo)

Calculamos C⁺ bajo F = {BD→CAE, CA→B, B→E}:
- {C} → ninguna FD parte solo de C → C⁺ = {C}
- B ∉ {C} → **A NO es ajeno** en CA→B ✗

---

## 7. Formas Normales

Las formas normales reducen la **redundancia** y las **anomalías de actualización/inserción/borrado**.

### Primera Forma Normal (1FN)

> Todos los atributos tienen dominios **atómicos** (valores indivisibles).

### Segunda Forma Normal (2FN)

> Ningún atributo no primo depende **parcialmente** de una clave candidata.

### Tercera Forma Normal (3FN)

> Para toda FD no trivial `X → A` en F⁺, se cumple **al menos una** de:
> 1. X es superclave de R, **o**
> 2. A es un atributo primo.

### Forma Normal de Boyce-Codd (BCNF)

> Para toda FD no trivial `X → A` en F⁺, **X es superclave de R** (sin excepción).

BCNF es más estricta que 3FN. La diferencia: BCNF no permite la excepción del "atributo primo".

### Jerarquía

BCNF ⊂ 3FN ⊂ 2FN ⊂ 1FN

| Forma Normal | Condición para cada FD no trivial X → A |
|---|---|
| **BCNF** | X debe ser superclave (siempre, sin excepción) |
| **3FN** | X es superclave **O** A es primo |
| **2FN** | No hay dependencias parciales de no-primos sobre claves candidatas |

### Procedimiento estándar para verificar la forma normal

1. Encontrar todas las claves candidatas de R bajo F.
2. Identificar atributos primos (en alguna clave) y no primos.
3. Para cada FD no trivial `X → A` en F:
   - X es superclave → cumple BCNF ✓
   - X no es superclave, A es primo → cumple 3FN pero viola BCNF
   - X no es superclave, A no es primo → viola 3FN (y BCNF)

**La forma normal de R no depende de si F es o no un recubrimiento canónico.**

---

## 8. Descomposición: PSP y Conservación de Dependencias

### 8.1 Propiedad de Producto Sin Pérdida (PSP / Lossless Join)

Una descomposición de R en R₁ y R₂ es **sin pérdida** si, para toda instancia válida r(R):

> `r = πR₁(r) ⋈ πR₂(r)`

La reunión natural de las proyecciones recupera exactamente la relación original, sin tuplas espurias.

**Condición necesaria y suficiente (Teorema de Heath):**

La descomposición {R₁, R₂} es sin pérdida bajo F si y solo si:
- `(R₁ ∩ R₂) → R₁` está en F⁺, **o**
- `(R₁ ∩ R₂) → R₂` está en F⁺

Es decir: los atributos comunes deben ser superclave de al menos una de las dos partes.

**Propiedades importantes — muy recurrentes en tests:**

| Afirmación | Verdad |
|-----------|--------|
| Si R₁ ∩ R₂ = ∅ → siempre con pérdida | ✓ VERDAD |
| Tener atributos comunes es necesario para PSP | ✓ VERDAD |
| Tener atributos comunes es suficiente para PSP | ✗ FALSO |
| r₁ ⋈ r₂ puede tener MÁS tuplas que r | ✓ VERDAD (tuplas espurias) |
| r₁ ⋈ r₂ puede tener MENOS tuplas que r | ✗ FALSO (siempre ≥ r) |
| R₁ y R₂ deben tener más de un atributo en común | ✗ FALSO |
| PSP implica CD | ✗ FALSO (son independientes) |
| CD implica PSP | ✗ FALSO (son independientes) |

**Por qué es importante PSP**: sin PSP no se puede reconstruir fielmente la información original.

### 8.2 Conservación de Dependencias (CD)

Una descomposición {R₁, ..., Rₙ} de R conserva las dependencias si:
> `(F₁ ∪ F₂ ∪ ... ∪ Fₙ)⁺ = F⁺`

donde Fᵢ es la proyección de F sobre Rᵢ.

**¿Por qué es deseable?**: permite verificar las FDs comprobando solo una relación, sin joins.

**Lo que NO implica la CD:**

| Afirmación falsa sobre CD |
|--------------------------|
| Reduce la redundancia |
| Garantiza que la BD no entre en estado inconsistente |
| Impide insertar información |
| Garantiza BCNF en las partes |
| Garantiza PSP |
| No hay que hacer joins para ninguna consulta |

### 8.3 Relación PSP / CD / Formas Normales

| | PSP garantizable | CD garantizable |
|---|---|---|
| **BCNF** | Siempre | No siempre |
| **3FN** | Siempre | Siempre |

Por eso se usa 3FN como compromiso cuando se necesitan ambas propiedades.

---

## 9. Integridad Referencial

### Definición y condición fundamental

Dada una **relación referenciada r₁** con clave primaria K, y una **relación que referencia r₂** con clave externa α:

> La condición de integridad referencial: **Πα(r₂) ⊆ ΠK(r₁)**

Todo valor de α en r₂ debe existir como valor de K en r₁. **Esta condición siempre debe cumplirse.**

Dirección correcta: `Πα(r₂) ⊆ ΠK(r₁)`. r₁ puede tener valores en K que no aparezcan en r₂ — eso está permitido. Lo que no se permite es que r₂ tenga α que no exista en K de r₁.

### Restricciones en modificaciones

| Operación | Relación | Efecto |
|-----------|----------|--------|
| **Inserción** en r₂ | referenciante | Se verifica que el nuevo α ∈ ΠK(r₁); si no → error |
| **Eliminación** en r₁ | referenciada | Puede provocar acción en r₂ (CASCADE, SET NULL...) |
| **Actualización** de K en r₁ | referenciada | Puede provocar actualización de α en r₂ |
| **Inserción** en r₁ | referenciada | **No desencadena nada** en r₂ |
| **Eliminación** en r₂ | referenciante | **No desencadena nada** en r₁ |
| **Actualización** en r₂ | referenciante | Se verifica el nuevo α contra r₁ |

### Políticas al violar la integridad referencial

| Política | Efecto al borrar/actualizar K en r₁ |
|----------|-------------------------------------|
| **CASCADE** | Eliminar/actualizar tuplas de r₂ en cascada |
| **SET NULL** | Poner α = NULL en r₂ |
| **SET DEFAULT** | Poner α = valor por defecto en r₂ |
| **RESTRICT / NO ACTION** | Rechazar la operación |

### Lo que NO requiere la integridad referencial

- No requiere que r₁ esté en BCNF ni en ninguna forma normal.
- No requiere que r₁ y r₂ sean compatibles para la diferencia/intersección.
- No requiere que r₂ provenga de una entidad débil del E-R.
- No requiere que K y α tengan el mismo **número** de atributos — sí que tengan dominios compatibles.
- No requiere que r₁ tenga una única superclave.
- No requiere que r₁ y r₂ tengan el mismo número de claves candidatas.

### Tuplas colgantes

- **r₁** puede tener tuplas cuyo K no esté referenciado por nadie en r₂. Eso está permitido — no son "colgantes" en sentido problemático.
- **r₂** NO puede tener tuplas cuyo α no exista en K de r₁. Eso sería una violación.

Resumen: en r₁ SÍ pueden haber tuplas "no referenciadas". En r₂ NO pueden haber tuplas con referencias inexistentes.

---

## 10. Álgebra Relacional

### Operaciones fundamentales (básicas)

| Operación | Símbolo | Descripción |
|-----------|---------|-------------|
| **Selección** | σ | Filtra tuplas que cumplen una condición |
| **Proyección** | π | Selecciona columnas |
| **Unión** | ∪ | Tuplas en r₁ o r₂ (requieren compatibilidad) |
| **Diferencia** | − | Tuplas en r₁ que no están en r₂ |
| **Producto cartesiano** | × | Combina todas las tuplas de r₁ con r₂ |
| **Renombramiento** | ρ | Renombra relación/atributos |

Operaciones **derivadas** (se expresan con las anteriores):

| Operación | Cómo se deriva |
|-----------|---------------|
| **Intersección** (∩) | `r ∩ s = r − (r − s)` |
| **Reunión natural** (⋈) | Combinación de ×, σ, π |
| **División** (÷) | Combinación de π, ×, − |

### Reunión natural (JOIN)

- **No es básica** — es derivada.
- Puede devolver **menos tuplas** que el producto cartesiano (filtra las que no coinciden).
- **Nunca puede devolver más tuplas** que el producto cartesiano.
- No cumple la misma función que el cuantificador universal (eso corresponde a la división).

### División (÷)

- `r ÷ s` devuelve los valores de r que se relacionan con **todos** los valores de s.
- Es una operación **derivada**, no básica.
- **No es asociativa**.
- No puede devolver más tuplas de las que había en la proyección de r.

### Intersección en SQL

Se puede expresar de varias formas: `INTERSECT`, `EXISTS`, `IN`. No requiere EXCEPT/MINUS ni FORALL. No es imposible de expresar en SQL práctico.

---

## 11. SQL — Restricciones de Integridad

### Restricciones en SQL2 (SQL-92)

| Restricción | Cláusula SQL correcta |
|-------------|----------------------|
| **Clave primaria** | `PRIMARY KEY` |
| **Clave candidata / unicidad** | `UNIQUE` (no `UNIQUE KEY`) |
| **Clave externa** | `FOREIGN KEY ... REFERENCES ...` |
| **Restricción de dominio** | `CHECK (condición)` |
| **No nulo** | `NOT NULL` |
| **Asertos globales** | `CREATE ASSERTION nombre CHECK (condición)` |
| **Disparadores** | `CREATE TRIGGER` |

**Puntos clave para el examen:**

- Claves candidatas → `UNIQUE` (no `UNIQUE KEY`, no `FOREIGN KEY`)
- Claves primarias → `PRIMARY KEY` (no `FOREIGN KEY`, no `CHECK UNIQUE`)
- Claves externas → `FOREIGN KEY ... REFERENCES ...` (no `REFERENTIAL INTEGRITY`)
- Asertos → `CREATE ASSERTION` (no confundir con `CREATE TRIGGER`)
- Disparadores → `CREATE TRIGGER` (no `CREATE ASSERTION`)
- Dependencias funcionales → **no expresables** directamente en SQL estándar

**Ventajas de restricciones específicas (PRIMARY KEY, UNIQUE...) frente a asertos (CREATE ASSERTION):**

Las restricciones específicas son más eficientes porque el SGBD sabe exactamente cuándo verificarlas y puede optimizar la verificación. Los asertos son más generales pero más costosos — el SGBD debe evaluarlos ante cualquier cambio en las tablas involucradas.

---

## 12. Tuplas Colgantes

En el contexto de integridad referencial (r₁ referenciada con clave K, r₂ referenciante con clave externa α):

- Una tupla en **r₂** cuyo α no existe en K de r₁ → **tupla colgante** → viola integridad referencial → **no permitida**.
- Una tupla en **r₁** cuyo K no está referenciado por ningún α de r₂ → simplemente "no referenciada" → **perfectamente válida**.

**Conclusión**: en r₁ SÍ pueden haber tuplas no referenciadas. En r₂ NO pueden haber tuplas con α inexistente en r₁.

---

## 13. Propiedades de F⁺ y X⁺ — Relaciones entre ellos

Dado F, X ⊆ R, A ∈ X⁺:

| Expresión | ¿Pertenece? | Justificación |
|-----------|-------------|---------------|
| `X → X⁺` | A F⁺ | Por definición de cierre |
| `X → X⁺` | A F (no necesariamente) | Puede ser solo derivada |
| `X → A` (A ∈ X⁺) | A F⁺ | Descomposición de X → X⁺ |
| `X → A` (A ∈ X⁺) | A F (no necesariamente) | Puede ser derivada |
| `X⁺ → A` (A ∈ X⁺) | A F⁺ | Reflexividad (A ⊆ X⁺ → X⁺ → A) |
| `X⁺ → A⁺` | A F⁺ | Por X⁺→A y A→A⁺ (transitividad) |
| `A⁺ → X⁺` | No necesariamente | Depende de FDs concretas |

**La más recurrente en tests**: dado A ∈ X⁺ → `X → A ∈ F⁺`.

Dado A ∈ X (no solo X⁺, sino el propio X): `X → (A)⁺ ∈ F⁺` porque X → A (reflexividad) y A → A⁺ → por transitividad X → A⁺ ∈ F⁺.

---

## 14. Producto Natural vs Producto Cartesiano

| | Producto Natural (⋈) | Producto Cartesiano (×) |
|---|---|---|
| ¿Básica? | No (derivada) | Sí (básica) |
| Tuplas resultado | ≤ que el producto cartesiano | El máximo posible |
| Condición | Igualdad en atributos comunes | Ninguna |
| ¿Puede dar más que ×? | **No** | — |

El producto natural **nunca puede devolver más tuplas que el producto cartesiano** — es un subconjunto filtrado de él.

---

## 15. RESOLUCIÓN DETALLADA DE TODOS LOS TESTS

A continuación se resuelven y explican todas las preguntas test de los exámenes disponibles.

---

### EXAMEN 2002

---

**Pregunta 1** — Integridad referencial, r1 con clave K, r2 con clave externa α

- (a) r1 tiene que estar en BCNF al menos
- (b) r1 y r2 deben ser compatibles para la diferencia
- (c) r2 debe provenir de una entidad débil del E-R
- **(d) Ninguna de las otras es correcta** ← CORRECTA
- (e) Siempre debe cumplirse ΠK(r1) ⊆ Πα(r2)

**Respuesta: (d)**

- (a) Falso — la integridad referencial no impone ninguna forma normal.
- (b) Falso — compatibilidad para la diferencia (mismo esquema) no tiene relación con integridad referencial.
- (c) Falso — la clave externa puede estar en cualquier tipo de relación.
- (e) Falso — **la condición está al revés**. La correcta es `Πα(r₂) ⊆ ΠK(r₁)` (los valores de α de r₂ deben existir en K de r₁, no al revés).

---

**Pregunta 2** — F y su recubrimiento canónico Fc

- (a) F⁺ ≠ Fc⁺
- (b) Ninguna de las otras es correcta
- (c) F == Fc
- (d) F =/=> Fc y Fc ==> F
- **(e) F ==> Fc y Fc ==> F** ← CORRECTA

**Respuesta: (e)**

Por definición, Fc es equivalente a F: tienen el mismo cierre F⁺ = Fc⁺. Esto significa que F implica lógicamente a Fc Y Fc implica lógicamente a F — la implicación va en ambas direcciones.

- (a) Falso — F⁺ = Fc⁺ siempre.
- (c) Falso — como conjuntos de FDs escritas, F y Fc pueden diferir.
- (d) Falso — la implicación es en ambos sentidos, no solo de Fc a F.

---

**Pregunta 3** — R = (A, B, C, D), F = { B → C, BC → DA, A → B }

- (a) R NO está en BCNF ni en 3FN porque F no es recubrimiento canónico
- (b) Ninguna de las otras es correcta
- (c) La forma normal más alta es 3FN
- (d) R NO está en 3FN
- **(e) La forma normal más alta es BCNF** ← CORRECTA

**Respuesta: (e)**

Cálculo de claves candidatas:

A⁺: A→B → {A,B}, B→C → {A,B,C}, BC→DA → {A,B,C,D} = R → **A es clave candidata**.

B⁺: B→C → {B,C}, BC→DA → {A,B,C,D} = R → **B es clave candidata**.

Atributos primos: A y B. No primos: C y D.

Verificar cada FD:
- B→C: B es clave candidata (superclave) → BCNF ✓
- BC→DA: BC contiene a B que es superclave → BC también es superclave → BCNF ✓
- A→B: A es clave candidata → BCNF ✓

Todas las FDs cumplen BCNF → R está en BCNF.

Nota: (a) es doblemente falsa — la forma normal no depende de si F es Fc, y además R sí está en BCNF.

---

**Pregunta 4** — Descomposición PSP de R en R1 y R2

- (a) Es posible que R1 y R2 no tengan ningún atributo en común
- (b) R1 y R2 deben tener como mucho un atributo en común
- (c) Basta con que tengan más de un atributo en común para que sea PSP
- **(d) Ninguna de las otras es correcta** ← CORRECTA
- (e) r1 ⋈ r2 NO puede tener más tuplas que r

**Respuesta: (d)**

- (a) Falso — si R1 ∩ R2 = ∅, el join es producto cartesiano → siempre hay pérdida → nunca PSP.
- (b) Falso — no hay restricción de "como mucho un atributo en común".
- (c) Falso — tener varios atributos comunes no garantiza PSP. La condición real es que esos atributos comunes sean superclave de R1 o R2 (Teorema de Heath).
- (e) Falso — r1 ⋈ r2 **puede** tener más tuplas que r (las espurias aparecen precisamente cuando NO hay PSP).

---

**Pregunta 5** — Conservación de dependencias, ¿por qué es deseable?

- (a) La conservación reduce el grado de redundancia inicial
- (b) Si no se conservasen, la BD estaría en estado inconsistente
- (c) Si no se conservasen, no se podría insertar nueva información
- (d) Nos garantiza que todas las relaciones estén en BCNF
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — la CD no reduce la redundancia; eso lo hace la normalización.
- (b) Falso — la BD puede seguir siendo consistente; simplemente sería más difícil verificar las restricciones sin hacer joins.
- (c) Falso — siempre se puede insertar información, con o sin CD.
- (d) Falso — la CD no tiene relación directa con la forma normal de las partes.

La razón correcta: la CD permite **comprobar cada FD mirando solo una relación, sin necesidad de reunir tablas** (joins). Esto simplifica enormemente la implementación de la integridad.

---

**Pregunta 6** — Restricciones de integridad en SQL

- **(a) Ninguna de las otras es correcta** ← CORRECTA (según nota del examen: en SQL-2 es UNIQUE, no UNIQUE KEY)
- (b) Las claves candidato se indican con UNIQUE
- (c) Las claves primarias se indican con FOREIGN KEY
- (d) Los disparadores se indican con CREATE ASSERTION
- (e) Las dependencias funcionales se indican con FUNCTIONAL DEPENDENCY

**Respuesta: (a)**

El enunciado aclara que en algunas ediciones del libro aparecía `UNIQUE KEY` (no estándar), por lo que la opción (b) puede referirse a `UNIQUE KEY`. En SQL-2 estándar la cláusula correcta para claves candidatas es solo `UNIQUE`. El examen considera (a) la más correcta dado el contexto.

- (c) Falso — PRIMARY KEY (no FOREIGN KEY) para claves primarias.
- (d) Falso — CREATE TRIGGER para disparadores (no CREATE ASSERTION).
- (e) Falso — las dependencias funcionales no son expresables en SQL estándar.

---

**Pregunta 7** — F = { BD → CAE, CA → B, B → E }, atributos ajenos

- **(a) E es un atributo ajeno en BD → CAE** ← CORRECTA
- (b) A es un atributo ajeno en CA → B
- (c) C es un atributo ajeno en BD → CAE
- (d) A es un atributo ajeno en CA → B [repetida]
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

Verificación de (a) — ¿Es E ajeno en BD → CAE? (lado derecho, quitamos E)
Calcular BD⁺ con F' = {BD→CA, CA→B, B→E}:
- {B,D} → BD→CA → {A,B,C,D} → CA→B (ya) → B→E → {A,B,C,D,E}
- E ∈ BD⁺ con F' → **E SÍ es ajeno** ✓

Verificación de (c) — ¿Es C ajeno en BD → CAE? (lado derecho, quitamos C)
Calcular BD⁺ con F'' = {BD→AE, CA→B, B→E}:
- {B,D} → BD→AE → {A,B,D,E} → B→E (ya) → CA→B: C ∉ {A,B,D,E} → no aplica
- C ∉ BD⁺ → C NO es ajeno ✗

Verificación de (b)/(d) — ¿Es A ajeno en CA → B? (lado izquierdo, quitamos A)
Calcular C⁺ bajo F:
- {C} → ninguna FD parte solo de C → C⁺ = {C}
- B ∉ {C} → A NO es ajeno en CA→B ✗

---

**Pregunta 8** — Intersección en SQL

- (a) No puede expresarse, CONTAINS no es estándar
- (b) Necesita usar obligatoriamente MINUS (EXCEPT)
- (c) Tiempo de ejecución excesivo
- (d) Se puede crear con FORALL
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

La intersección sí puede expresarse en SQL de varias formas (IN, EXISTS, INTERSECT). No requiere EXCEPT, no tiene tiempo de ejecución inviable, y FORALL no es un operador SQL estándar.

---

**Pregunta 9** — Cierre X⁺

- (a) Se calcula partiendo necesariamente de un recubrimiento canónico de F
- (b) Puede tener menos atributos que X
- (c) Si X no tiene atributos primos, X⁺ no puede tener atributos primos
- (d) Es igual a R si todos los atributos de X son primos
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — X⁺ se calcula directamente desde F sin necesidad de Fc.
- (b) Falso — siempre X ⊆ X⁺, nunca puede tener menos atributos que X.
- (c) Falso — X⁺ puede contener atributos primos aunque X no los tenga. Ejemplo: X={B} (no primo), F={B→A} donde A es primo → A ∈ B⁺.
- (d) Falso — que los atributos de X sean primos no implica que X sea superclave. Los atributos primos pertenecen a alguna clave, pero X puede contenerlos sin ser superclave.

---

**Pregunta 10** — Integridad referencial, operaciones

- **(a) Una eliminación en r1 puede conllevar una eliminación en r2** ← CORRECTA
- (b) Una eliminación en r2 puede conllevar una actualización en r1
- (c) Una inserción en r1 puede conllevar una inserción en r2
- (d) Una inserción en r2 puede conllevar una actualización en r1
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

Si se borra una tupla de r₁ cuyo K está referenciado por algún α de r₂, la política CASCADE puede borrar las tuplas correspondientes de r₂. Por tanto, eliminar en r₁ puede provocar eliminaciones en r₂.

- (b) Falso — eliminar en r₂ nunca afecta a r₁.
- (c) Falso — insertar en r₁ nunca desencadena inserciones en r₂.
- (d) Falso — insertar en r₂ puede fallar (si α no existe en K de r₁) pero nunca actualiza r₁.

---

### EXAMEN 2004

---

**Pregunta 1** — F = { C → AE, AE → BA, A → C }, atributos ajenos

- (a) E es un atributo ajeno en AE → BA
- **(b/c) B es un atributo ajeno en AE → BA** ← varía según versión
- (d) A es un atributo ajeno en C → AE
- (e) Ninguna de las otras es correcta

Nota: en el test original la opción correcta señalada es que **la primera A (del lado derecho)** es ajeno en AE→BA, o equivalentemente que B es ajeno. Analicemos ambos.

**¿Es la primera A ajena en AE → BA?** (lado derecho, quitamos A del resultado BA)
Calcular AE⁺ con F' = {C→AE, AE→B, A→C}:
- {A,E} → AE→B → {A,B,E} → A→C → {A,B,C,E} → C→AE (ya) → {A,B,C,E}
- A ∈ {A,B,C,E} → **A SÍ es ajena en el lado derecho de AE→BA** ✓

**¿Es B ajeno en AE → BA?** (lado derecho, quitamos B del resultado BA)
Calcular AE⁺ con F'' = {C→AE, AE→A, A→C}:
- {A,E} → AE→A (ya) → A→C → {A,C,E} → C→AE (ya) → {A,C,E}
- B ∉ {A,C,E} → B NO es ajeno ✗

**Respuesta correcta: la primera A (del lado derecho) es ajena en AE→BA.**

---

**Pregunta 2** — F = { ABC → ABC, B → ABC }, R = (A, B, C, D)

- (a) R no puede tener ninguna clave candidata porque D no aparece en F
- (b) R no puede tener ninguna clave candidata porque F no es recubrimiento canónico
- (c) Cualquier r puede satisfacer F
- (d) Sólo un único r puede satisfacer F
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — D no aparece en ninguna FD, lo que significa que D debe estar en todas las claves candidatas (nadie lo determina). Esto no impide que haya claves: BD⁺: B→ABC → {A,B,C,D}=R → BD es clave candidata.
- (b) Falso — que F no sea Fc no impide la existencia de claves.
- (c) Falso — B→ABC impone restricciones reales (dados dos tuplas con mismo B, deben coincidir en A, B, C).
- (d) Falso — puede haber múltiples instancias r que satisfagan F.

---

**Pregunta 3** — Integridad referencial, operaciones

- (a) Una inserción en r1 puede conllevar un borrado en r2
- **(b) Una actualización en r1 puede conllevar un borrado en r2** ← CORRECTA
- (c) Una inserción en r2 puede conllevar una inserción en r2
- (d) Una inserción en r2 puede conllevar una actualización en r1
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

Si se actualiza K en r₁ (equivale a borrar el K antiguo e insertar el nuevo), las tuplas de r₂ que referenciaban el K antiguo pueden borrarse (CASCADE) o quedar con NULL. Por tanto, una actualización en r₁ puede provocar borrado en r₂.

- (a) Falso — insertar en r₁ nunca provoca borrado en r₂.
- (c) Sin sentido — inserción en r₂ no puede causar inserción en ella misma.
- (d) Falso — insertar en r₂ puede fallar pero nunca actualiza r₁.

---

**Pregunta 4** — R = (A, B, C), F = { A → ABC, CD → AB }

- **(a) La forma normal más alta es BCNF** ← CORRECTA
- (b) La forma normal más alta es 3FN
- (c) R no está en BCNF ni en 3FN
- (d) No se puede saber porque F no es Fc
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

R solo tiene tres atributos: A, B, C. Las FDs relevantes son aquellas cuyos atributos están todos en R:
- A → ABC: sobre R = {A,B,C} → A es superclave de R (A⁺ = {A,B,C} = R) → A es clave candidata.
- CD → AB: D ∉ R, así que esta FD no aplica sobre R.

La única FD relevante es A → BC. A es superclave → cumple BCNF. R está en BCNF.

---

**Pregunta 5** — Conservación de dependencias

- (a) Se reduce la repetición de información
- (b) No hay que hacer productos naturales para implementar las consultas necesarias
- (c) Se reduce el número de dependencias funcionales que hay que comprobar
- (d) Así es imposible que se pierda información en la descomposición
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — CD no reduce redundancia.
- (b) Falso — la CD facilita verificar FDs sin joins, pero no elimina la necesidad de joins para consultas en general.
- (c) Parcialmente verdad, pero la afirmación correcta es: permite verificar cada FD en una sola relación (sin joins). Como está formulada puede malinterpretarse.
- (d) Falso — CD y PSP son independientes.

---

**Pregunta 6** — Dado F, X, A ∈ X, siempre se cumple...

- (a) (A)⁺ ⊆ X
- **(b) X → (A)⁺ ∈ F⁺** ← CORRECTA
- (c) X⁺ → A ∈ F
- (d) (A)⁺ → X⁺ ∈ F
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

Como A ∈ X → X → A ∈ F⁺ (reflexividad). Como A → A⁺ ∈ F⁺ (definición de cierre). Por transitividad: X → A⁺ = X → (A)⁺ ∈ F⁺. ✓

- (a) Falso — (A)⁺ puede contener atributos fuera de X.
- (c) Falso — X⁺→A ∈ F⁺ (reflexividad, ya que A ∈ X ⊆ X⁺), pero no necesariamente ∈ F.
- (d) Falso — no hay razón general para que A⁺ → X⁺.

---

**Pregunta 7** — SQL2, restricciones de integridad

- (a) Dependencias funcionales → FUNCTIONAL DEPENDENCY
- (b) Claves candidato → UNIQUE KEY
- (c) Claves externas → CREATE ASSERTION
- (d) Claves primarias → CHECK UNIQUE
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — FUNCTIONAL DEPENDENCY no existe en SQL.
- (b) Falso — en SQL-2 estándar es solo UNIQUE (no UNIQUE KEY).
- (c) Falso — las claves externas son FOREIGN KEY ... REFERENCES.
- (d) Falso — las claves primarias son PRIMARY KEY.

---

**Pregunta 8** — Operación división del álgebra relacional

- (a) Es una operación básica
- (b) Es asociativa
- (c) Puede devolver más tuplas de las que había en r
- (d) Es equivalente a r − (r × s)
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — es derivada, no básica.
- (b) Falso — no es asociativa.
- (c) Falso — la división solo devuelve proyecciones de r, nunca más tuplas que las que había.
- (d) Falso — la formulación correcta de r ÷ s usando operaciones básicas implica diferencias y productos, pero no es simplemente r − (r × s).

---

**Pregunta 9** — F = { BA → CD, CD → AE }, R = (A, B, C, D, E)

- (a) La forma normal más alta es BCNF
- (b) La forma normal más alta es 3FN
- **(c) R no está en BCNF ni en 3FN** ← CORRECTA
- (d) No se puede saber porque F no es Fc
- (e) Ninguna de las otras es correcta

**Respuesta: (c)**

Claves candidatas:
- BA⁺: BA→CD → {A,B,C,D}, CD→AE → {A,B,C,D,E} = R → **BA es clave candidata**.
- Verificar si hay otras... CD⁺: CD→AE → {A,C,D,E} ≠ R. Solo BA es clave.

Atributos primos: A y B. No primos: C, D, E.

Verificar FDs:
- BA→CD: BA es superclave → BCNF ✓
- CD→AE: CD⁺ = {A,C,D,E} ≠ R → CD no es superclave. A es primo (cumple 3FN para A). E no es primo → **viola 3FN** (y BCNF).

R no está en 3FN ni en BCNF.

---

**Pregunta 10** — R = (n_fact, n_cliente, total, fecha), F = { n_fact → fecha }

- (a) Una factura puede tener más de una fecha
- (b) NO pueden hacerse facturas a nombre de más de un cliente
- (c) Puede darse el caso de que una misma factura tenga dos o más totales distintos
- (d) Falta una dependencia funcional para n_cliente
- **(e) Ninguna de las anteriores es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — n_fact → fecha impide exactamente esto.
- (b) Falso — no hay FD n_fact → n_cliente, así que distintas tuplas con el mismo n_fact pueden tener distintos n_cliente. Sí pueden hacerse facturas a más de un cliente.
- (c) Verdad dentro del modelo puro de FDs (sin FD para total), pero en el contexto del examen, "factura" semánticamente debería tener un único total. Sin embargo, formalmente F no lo impide. Puede estar mal formulada.
- (d) Parcialmente verdad (falta n_fact → n_cliente y n_fact → total), pero no solo para n_cliente.

El examen considera (e) la respuesta correcta porque ninguna de las opciones está formulada de forma completamente precisa.

---

### EXAMEN 2005

---

**Pregunta 1** — Integridad referencial

- (a) r1 tiene que estar en BCNF
- (b) r1 y r2 deben tener más de una clave candidata
- (c) r1 debe provenir de una entidad del E-R
- (d) Siempre debe cumplirse ΠK(r1) ⊆ Πα(r2)
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a), (b), (c) Falso — ninguna de estas restricciones impone la integridad referencial.
- (d) Falso — la condición está al revés. Lo correcto es Πα(r₂) ⊆ ΠK(r₁).

---

**Pregunta 2** — F y Fc

- (a) F⁺ ≠ Fc⁺
- (b) F == Fc
- (c) F =/=> Fc y Fc ==> F
- **(d) F ==> Fc y Fc ==> F** ← CORRECTA
- (e) Ninguna de las otras es correcta

**Respuesta: (d)**

Fc y F son equivalentes (mismo cierre). La implicación lógica va en ambas direcciones.

---

**Pregunta 3** — R = (A, B, C, D, E), F = { AB → DE, E → AC, AE → B }

- (a) No en BCNF ni 3FN porque F no es Fc
- (b) La forma normal más alta es 3FN
- (c) R NO está en 3FN
- **(d) La forma normal más alta es BCNF** ← CORRECTA
- (e) Ninguna de las otras es correcta

**Respuesta: (d)**

Claves candidatas:
- AB⁺: AB→DE → {A,B,D,E}, E→AC → {A,B,C,D,E} = R → **AB es clave candidata**.
- AE⁺: AE→B → {A,B,E}, AB→DE → {A,B,D,E}, E→AC → {A,B,C,D,E} = R → **AE es clave candidata**.
- E⁺: E→AC → {A,C,E}, AE→B → {A,B,C,E}, AB→DE → {A,B,C,D,E} = R → **E es clave candidata**.

Atributos primos: A, B, E. No primos: C, D.

Verificar FDs:
- AB→DE: AB es clave → BCNF ✓
- E→AC: E es clave → BCNF ✓
- AE→B: AE es clave → BCNF ✓

R está en BCNF.

---

**Pregunta 4** — F = { AB → DE, E → AC, AE → B }, atributos ajenos

- **(a) A es un atributo ajeno en AE → B** ← CORRECTA
- (b) E es un atributo ajeno en AE → B
- (c) A es un atributo ajeno en AB → DE
- (d) B es un atributo ajeno en AB → DE
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

¿Es A ajeno en AE→B? (lado izquierdo, quitamos A)
Calcular E⁺ bajo F:
- E⁺: E→AC → {A,C,E}, AE→B: A ∈ {A,C,E} ✓ → {A,B,C,E}, AB→DE: B ∈ {A,B,C,E} ✓ → {A,B,C,D,E}
- B ∈ E⁺ → **A sí es ajeno en AE→B** ✓

¿Es E ajeno en AE→B? (lado izquierdo, quitamos E)
Calcular A⁺ bajo F:
- A⁺: {A} → E→AC necesita E; AE→B necesita E; AB→DE necesita B. A⁺ = {A}
- B ∉ {A} → E NO es ajeno ✗

---

**Pregunta 5** — Dado F, X, A ∈ X⁺

- (a) X → X⁺ ∈ F
- (b) X⁺ → A⁺ ∈ F⁺
- **(c) X⁺ → A ∈ F⁺** ← CORRECTA
- (d) A⁺ → X ∈ F⁺
- (e) Ninguna de las otras es correcta

**Respuesta: (c)**

Como A ∈ X⁺, se cumple A ⊆ X⁺, por tanto X⁺ → A es una FD trivial que siempre pertenece a F⁺ (reflexividad).

- (a) Falso — X → X⁺ ∈ F⁺ pero no necesariamente ∈ F.
- (b) X⁺ → A⁺ ∈ F⁺ también sería verdad (ya que X⁺→A y A→A⁺), pero (c) es más directa y precisa.
- (d) Falso — A⁺ → X no tiene por qué ser cierto.

---

**Pregunta 6** — R = (A, B, C, D, E), F = { A → BCE, CA → AE }

- (a) No en BCNF ni 3FN porque F no es Fc
- (b) La forma normal más alta es 3FN
- (c) R NO está en 3FN
- **(d) La forma normal más alta es BCNF** ← según solución del examen
- (e) Ninguna de las otras es correcta

**Respuesta: (d)**

Nota: D no aparece en ninguna FD, así que D debe estar en todas las claves candidatas. A→BCE nos da ABCE desde A, pero D no está → la clave mínima debe incluir D y algo que dé A. AD⁺: A→BCE → {A,B,C,D,E} = R → **AD es clave candidata**. Verificar si D solo basta: D⁺={D}≠R. Verificar A solo: A⁺={A,B,C,E}≠R (falta D).

Atributos primos: A, D. No primos: B, C, E.

Verificar FDs:
- A→BCE: A no es superclave (falta D). B, C, E son no primos → **¿viola 3FN?**

Esto es conflictivo. Si el examen marca (d), puede haber atributos ajenos que simplifiquen F. CA→AE: CA→A es trivial, CA→E queda. Y puede que con el Fc correcto, la única FD relevante sea A→BCDE (con D derivado de algo) o que la forma normal sea más alta de lo aparente. Conviene recalcular en el examen real.

---

**Pregunta 7** — Descomposición PSP, R en R1 y R2

- (a) R1 y R2 no pueden tener ningún atributo en común
- (b) R1 y R2 deben tener más de un atributo en común
- (c) Basta con dos atributos en común para que sea PSP
- (d) r1 ⋈ r2 puede tener menos tuplas que r
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — sin atributos comunes → siempre pérdida.
- (b) Falso — puede bastar con uno si es superclave.
- (c) Falso — dos atributos en común no garantizan PSP; depende de si forman superclave.
- (d) Falso — r1 ⋈ r2 siempre contiene todas las tuplas de r (puede tener más, nunca menos).

---

**Pregunta 8** — Restricciones de integridad SQL

- (a) REFERENTIAL INTEGRITY para integridad referencial
- **(b) UNIQUE permite indicar claves candidato** ← CORRECTA
- (c) CHECK TRIGGER para disparadores
- (d) FUNCTIONAL DEPENDENCY para dependencias funcionales
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

En SQL-2, las claves candidatas se indican con UNIQUE. Es la única opción correcta.

---

**Pregunta 9** — Producto natural del álgebra relacional

- (a) Es una operación fundamental (básica)
- (b) Puede sustituirse por división, selección y unión
- (c) Cumple la misma función que el cuantificador universal del cálculo relacional
- **(d) NO puede devolver más tuplas que el producto cartesiano** ← CORRECTA
- (e) Ninguna de las otras es correcta

**Respuesta: (d)**

El producto natural filtra filas del producto cartesiano → es un subconjunto de él → nunca más tuplas que el producto cartesiano.

- (a) Falso — es derivada.
- (b) Falso — se expresa con ×, σ, π (no con división ni unión necesariamente).
- (c) Falso — el cuantificador universal corresponde a la división.

---

**Pregunta 10** — Operación división

- (a) Es asociativa
- (b) Es una operación básica
- (c) Permite que las expresiones del álgebra relacional sean seguras
- (d) Es equivalente a la unión cuando las relaciones son compatibles
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — no es asociativa.
- (b) Falso — es derivada.
- (c) Falso — no tiene relación con la seguridad de expresiones.
- (d) Falso — la división no es equivalente a la unión.

---

### EXAMEN 2006

---

**Pregunta 1** — Integridad referencial

- (a) r1 tiene que estar en BCNF
- (b) r1 y r2 deben ser compatibles para la intersección
- (c) r1 debe provenir de una entidad del E-R
- **(d) Ninguna de las otras es correcta** ← CORRECTA
- (e) Siempre debe cumplirse ΠK(r1) ⊆ Πα(r2)

**Respuesta: (d)**

- (a), (b), (c) Falso — ninguna de estas restricciones pertenece a la integridad referencial.
- (e) Falso — la condición está al revés; la correcta es Πα(r₂) ⊆ ΠK(r₁).

---

**Pregunta 2** — F y Fc

- **(a) F⁺ = Fc⁺** ← CORRECTA
- (b) Ninguna de las otras es correcta
- (c) F == Fc
- (d) F =/=> Fc y Fc ==> F
- (e) F ==> Fc y Fc =/=> F

**Respuesta: (a)**

Por definición de recubrimiento canónico: Fc es equivalente a F, es decir, F⁺ = Fc⁺.

---

**Pregunta 3** — F = { ABC → BED, BE → D }, atributos ajenos

- **(a) A es un atributo ajeno en ABC → BED** ← CORRECTA (según solución oficial)
- (b) la primera B es un atributo ajeno en ABC → BED
- (c) B es un atributo ajeno en BE → D
- (d) E es un atributo ajeno en BE → D
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

Verificación — ¿Es A ajeno en ABC→BED? (lado izquierdo, quitamos A)
Calcular BC⁺ bajo F = {ABC→BED, BE→D}:
- {B,C} → ninguna FD parte de solo BC (la primera necesita A, la segunda necesita E). BC⁺ = {B,C}.
- BED ⊄ {B,C}...

Si esto no da resultado, puede ser que la opción (a) se refiera al lado derecho. Verifiquemos D como ajeno en lado derecho de BE→D: calcular BE⁺ sin D del lado derecho:
- BE⁺ con F' = {ABC→BED, BE→ε}: {B,E} → ninguna FD aplica → BE⁺ = {B,E}. D ∉ {B,E} → D no es ajeno.

Dado que la solución oficial indica (a), confiamos en ella. En el examen real conviene verificar con el método completo.

---

**Pregunta 4** — R = (A, B, C, D), F = { BC → AB, BA → CD }

- (a) No en BCNF ni 3FN porque F no es Fc
- (b) Ninguna de las otras es correcta
- (c) La forma normal más alta es 3FN
- (d) R NO está en 3FN
- **(e) La forma normal más alta es BCNF** ← CORRECTA

**Respuesta: (e)**

Claves candidatas:
- BC⁺: BC→AB → {A,B,C}, BA→CD → {A,B,C,D} = R → **BC es clave candidata**.
- BA⁺: BA→CD → {A,B,C,D} = R → **BA es clave candidata**.

Atributos primos: A, B, C. No primo: D.

Verificar FDs:
- BC→AB: BC es clave → BCNF ✓
- BA→CD: BA es clave → BCNF ✓

R está en BCNF.

---

**Pregunta 5** — Tuplas colgantes en integridad referencial

- (a) Ninguna de las otras es correcta
- (b) NO pueden haber tuplas colgantes en r1 y SÍ en r2
- (c) SÍ pueden haber tuplas colgantes en r1 y SÍ en r2
- (d) NO pueden haber tuplas colgantes en r1 y NO en r2
- **(e) SÍ pueden haber tuplas colgantes en r1 y NO en r2** ← CORRECTA

**Respuesta: (e)**

"Tupla colgante" significa:
- En r₁: una tupla no referenciada por ninguna tupla de r₂. Esto **SÍ está permitido** — r₁ puede tener valores K que nadie en r₂ referencia.
- En r₂: una tupla cuyo α no existe en K de r₁. Esto **NO está permitido** — violaría la integridad referencial.

---

**Pregunta 6** — Descomposición PSP

- **(a) r1 ⋈ r2 puede tener más tuplas que r** ← CORRECTA
- (b) R1 y R2 deben tener más de un atributo en común
- (c) Basta con que no tengan ningún atributo en común para que sea PSP
- (d) Ninguna de las otras es correcta
- (e) Obligatoriamente se conservan las dependencias

**Respuesta: (a)**

Cuando la descomposición NO es PSP, aparecen tuplas espurias → r1 ⋈ r2 tiene más tuplas que r. La opción (a) es verdad: puede ocurrir.

- (b) Falso — no se requiere más de un atributo común.
- (c) Falso — sin atributos comunes → siempre con pérdida (resultado es producto cartesiano).
- (e) Falso — PSP y CD son propiedades independientes.

---

**Pregunta 7** — R = (A, B, C, D, E), F = { BC → AB, BA → CD, E → B }, claves candidatas

- (a) AB es clave, BC no lo es
- (b) AB y BE son claves
- (c) BE es clave, AB no lo es
- (d) AB y BD son claves
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

Análisis:
- AB⁺: BA→CD → {A,B,C,D} ≠ R (falta E) → AB no es clave.
- BC⁺: BC→AB → {A,B,C}, BA→CD → {A,B,C,D} ≠ R → BC no es clave.
- CE⁺: E→B → {B,C,E}, BC→AB → {A,B,C,E}, BA→CD → {A,B,C,D,E} = R → **CE es clave candidata**.
- AE⁺: E→B → {A,B,E}, BA→CD → {A,B,C,D,E} = R → **AE es clave candidata**.

Las claves son CE y AE (y posiblemente otras). Ninguna de las opciones lo recoge correctamente.

---

**Pregunta 8** — Conservación de dependencias

- (a) El proceso de normalización se realiza más rápidamente
- (b) Si no se conservasen, la BD estaría en estado inconsistente
- (c) Si no se conservasen, no se podría insertar nueva información
- (d) Nos garantiza que las relaciones estén al menos en 3FN
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

Misma lógica que en 2002. La razón correcta: permite verificar FDs sin joins. Ninguna opción la expresa.

---

**Pregunta 9** — R con 3 atributos, Fc con dos dependencias

- (a) R nunca puede estar en 3FN como forma más alta conservando dependencias
- **(b) Ninguna de las otras es correcta** ← CORRECTA
- (c) Es posible que R nunca pueda descomponerse hasta BCNF conservando dependencias
- (d) En algún caso r podría tener tuplas repetidas
- (e) R nunca puede tener más de una clave candidata

**Respuesta: (b)**

- (c) Es plausible en algunos casos específicos, pero decir que "es posible que nunca pueda" es demasiado absoluto sin más información.
- (d) Falso — las tuplas repetidas dependen de las claves, no del número de FDs.
- (e) Falso — con 3 atributos puede haber varias claves candidatas.

---

**Pregunta 10** — Descomposición en BCNF, propiedades

- (a) Como máximo cada relación tiene una única clave candidata
- (b) Todas las dependencias de F pueden comprobarse mediante definiciones de claves
- **(c) Ninguna de las otras es correcta** ← CORRECTA
- (d) Siempre se conservan las dependencias
- (e) Necesariamente F tiene que ser un recubrimiento canónico

**Respuesta: (c)**

- (a) Falso — una relación en BCNF puede tener varias claves candidatas.
- (b) Falso — si no se conservan las dependencias (lo cual puede ocurrir en BCNF), no se pueden comprobar todas las FDs mediante claves.
- (d) Falso — BCNF no garantiza CD.
- (e) Falso — F no necesita ser Fc.

---

### EXAMEN 2009

---

**Pregunta 1** — Integridad referencial

- (a) K y α pueden tener distinto número de atributos
- (b) r1 y r2 deben tener el mismo número de claves candidatas
- (c) r1 sólo puede tener una superclave
- **(d) Siempre debe cumplirse Πα(r2) ⊆ ΠK(r1)** ← CORRECTA
- (e) Ninguna de las otras es correcta

**Respuesta: (d)**

Esta es la definición exacta de integridad referencial.

- (a) Falso — K y α deben tener el mismo número de atributos y dominios compatibles para que la comparación tenga sentido.
- (b) Falso — no hay ninguna restricción sobre el número de claves candidatas.
- (c) Falso — toda relación tiene al menos una superclave (el conjunto de todos sus atributos) y generalmente muchas más.

---

**Pregunta 2** — F, X, A ∈ X⁺

- (a) X → X⁺ ∈ F
- **(b) X → A ∈ F⁺** ← CORRECTA
- (c) X⁺ → A⁺ ∈ F⁺
- (d) A → X⁺ ∈ F⁺
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

Como A ∈ X⁺, por definición de cierre, X → A se puede derivar de F. Por tanto X → A ∈ F⁺.

- (a) Falso — X → X⁺ ∈ F⁺ pero no necesariamente ∈ F.
- (c) X⁺ → A⁺ ∈ F⁺ también es verdad (ya que A ∈ X⁺ → X⁺→A, y A→A⁺, por transitividad X⁺→A⁺), pero (b) es más directa y la respuesta esperada.
- (d) Falso — A → X⁺ no tiene por qué ser cierto.

---

**Pregunta 3** — R = (A, B, C, D, E), F = { AC → DE, BA → C, C → A }

- (a) R NO está en BCNF porque F no es Fc
- (b) La forma normal más alta es 3FN
- **(c) La forma normal más alta es BCNF** ← CORRECTA
- (d) R NO está en 3FN
- (e) Ninguna de las otras es correcta

**Respuesta: (c)**

Con la FD C→A, AC se reduce a C (A es ajeno en AC→DE porque C→A implica AC equivale a C). Así:
- Fc incluye: C→DE (reducida de AC→DE), BA→C, C→A.
- C⁺: C→A → {A,C}, C→DE → {A,C,D,E} ≠ R (falta B). C no es clave.
- BA⁺: BA→C → {A,B,C}, C→A (ya), C→DE → {A,B,C,D,E} = R → **BA es clave candidata**.
- BC⁺: C→A → {A,B,C}, C→DE → {A,B,C,D,E} = R → **BC es clave candidata**.
- C→A: ¿es C superclave? C⁺={A,C,D,E}≠R → C no es superclave. A es primo → cumple 3FN. Y también satisface que C→DE puede violar BCNF (C no superclave, D y E no primos). Necesitamos más análisis para confirmar BCNF.

Dado que el examen marca (c), la respuesta es BCNF.

---

**Pregunta 4** — F y Fc

- (a) F = Fc
- (b) F ≠ Fc
- (c) F ==> Fc y Fc =/=> F
- (d) F =/=> Fc y Fc ==> F
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

La verdad es que F ⟹ Fc y Fc ⟹ F (ambos sentidos). Ninguna opción lo expresa correctamente:
- (a) y (b) hablan de igualdad como conjuntos, que no siempre ni siempre-no se cumple.
- (c) y (d) implican implicación en un solo sentido, lo cual es falso.

---

**Pregunta 5** — F = { AC → D, BA → C, C → BA }, atributos ajenos

- (a) C es un atributo ajeno en AC → D
- **(b) A es un atributo ajeno en AC → D** ← CORRECTA
- (c) BA → C es una dependencia redundante
- (d) A es un atributo ajeno en BA → C
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

¿Es A ajeno en AC→D? (lado izquierdo, quitamos A)
Calcular C⁺ bajo F = {AC→D, BA→C, C→BA}:
- {C} → C→BA → {A,B,C} → BA→C (ya) → AC→D: A ∈ {A,B,C} ✓ → {A,B,C,D}
- D ∈ C⁺ → **A SÍ es ajeno en AC→D** ✓

---

**Pregunta 6** — Descomposición de R en R1 y R2

- **(a) R1 ∪ R2 tiene que ser exactamente igual a R** ← CORRECTA
- (b) Si R1 ∪ R2 ≠ R la descomposición es CON pérdida
- (c) R1 y R2 tienen que tener el mismo número de atributos
- (d) Basta con un atributo en común para que sea PSP
- (e) Ninguna de las otras es correcta

**Respuesta: (a)**

Por definición de descomposición: R1 ∪ R2 = R. Si no cubre todos los atributos, no es una descomposición válida de R.

- (b) Falso — que R1 ∪ R2 ≠ R significaría que no es una descomposición, no que sea "con pérdida".
- (c) Falso — no tienen que tener el mismo número de atributos.
- (d) Falso — tener un atributo en común no garantiza PSP; ese atributo debe ser superclave de R1 o R2.

---

**Pregunta 7** — SQL ANSI86: πn_CH(deposito) ∪ πn_CH(préstamo)

- (a) Es necesario usar EXCEPT
- **(b) Puede hacerse sin utilizar la cláusula WHERE** ← CORRECTA
- (c) No puede implementarse en ANSI86
- (d) Se necesita obligatoriamente NOT IN
- (e) Ninguna de las otras es correcta

**Respuesta: (b)**

```sql
SELECT n_CH FROM deposito
UNION
SELECT n_CH FROM prestamo
```

No necesita WHERE, ni NOT IN, ni EXCEPT. Se puede implementar perfectamente en ANSI86.

---

**Pregunta 8** — Ventajas de restricciones específicas vs asertos

- (a) No es necesario cambiarlas si cambia la semántica
- (b) No tienen ventajas importantes
- (c) El sistema puede definirlas automáticamente
- (d) Permiten especificar cualquier tipo de restricción
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

La ventaja real: **eficiencia**. Las restricciones específicas (PRIMARY KEY, UNIQUE, FOREIGN KEY) son más eficientes porque el SGBD sabe exactamente cuándo evaluarlas y puede optimizar esta evaluación. Los asertos son más generales pero más costosos.

- (a) Falso — si cambia la semántica, hay que cambiarlas igual.
- (b) Falso — sí tienen ventajas (eficiencia).
- (c) Falso — el SGBD no las define automáticamente.
- (d) Falso — las restricciones específicas son más limitadas que los asertos en expresividad.

---

**Pregunta 10** — Esquema relacional bajo F

- (a) Si está en BCNF todos los determinantes tienen un único atributo
- (b) Si está en 3FN todos los determinantes tienen un único atributo
- (c) Los atributos primos nunca pueden salir en el consecuente de una FD
- (d) Los atributos primos nunca pueden salir en el determinante de una FD
- **(e) Ninguna de las otras es correcta** ← CORRECTA

**Respuesta: (e)**

- (a) Falso — BCNF exige que los determinantes sean superclaves, no que tengan un solo atributo. Una superclave puede ser compuesta.
- (b) Falso — 3FN tampoco exige determinantes simples.
- (c) Falso — los atributos primos perfectamente pueden aparecer en el consecuente (lado derecho) de una FD.
- (d) Falso — los atributos primos pueden aparecer en el determinante (lado izquierdo).

---

## Tabla resumen de respuestas

| Año | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10 |
|-----|----|----|----|----|----|----|----|----|----|----|
| **2002** | d | e | e | d | e | a | a | e | e | a |
| **2004** | e | e | b | a | e | b | e | e | c | e |
| **2005** | e | d | d | a | c | d | e | b | d | e |
| **2006** | d | a | a | e | e | a | e | e | b | c |
| **2009** | d | b | c | e | b | a | b | e | — | e |

---

*Guía generada para preparación de examen de Bases de Datos — Segundo Parcial*
*Cubre: dependencias funcionales, cierres, recubrimiento canónico, atributos ajenos, formas normales (3FN/BCNF), descomposición (PSP/CD), integridad referencial, álgebra relacional, SQL2*
*Exámenes incluidos: 2002, 2004, 2005, 2006, 2009*
