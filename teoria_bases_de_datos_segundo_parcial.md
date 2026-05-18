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
12. [Resumen Rápido para las Preguntas](#12-resumen-rápido-de-las-preguntas)

---

## 1. Dependencias Funcionales

### ¿Qué es una dependencia funcional?

Una **dependencia funcional (FD)** `X → Y` sobre un esquema de relación R significa:

> Para toda relación r(R) válida, si dos tuplas tienen los mismos valores en X, también tienen los mismos valores en Y.

Ejemplo: `n_libro → título` significa que dado un número de libro, siempre obtenemos el mismo título.

### Tipos de dependencias

| Tipo | Definición |
|------|-----------|
| **Trivial** | `X → Y` donde `Y ⊆ X` (ej: `AB → A`) |
| **No trivial** | `X → Y` donde `Y ⊄ X` |
| **Completamente no trivial** | `X → Y` donde `X ∩ Y = ∅` |
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

Dos conjuntos F y G son **equivalentes** si y solo si `F⁺ = G⁺`.

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

Como A⁺ = ABCD = R, **A es superclave** (y en este caso clave candidata si ningún subconjunto propio lo es).

### Propiedades importantes de X⁺

- Siempre `X ⊆ X⁺` (por reflexividad, X siempre está en su propio cierre).
- **Nunca puede tener menos atributos que X**.
- X es superclave de R ⟺ X⁺ = R.
- `X → Y` está en F⁺ ⟺ `Y ⊆ X⁺`.
- **No es necesario calcular desde Fc** — se puede calcular desde F directamente (ambos dan el mismo resultado si F y Fc son equivalentes).

---

## 3. Claves

### Superclave

Un conjunto de atributos K es **superclave** de R si `K⁺ = R` (determina todos los atributos).

### Clave candidata

Una superclave **minimal**: ningún subconjunto propio suyo es también superclave.

### Clave primaria

Una clave candidata elegida como identificador principal de la relación.

### Cómo encontrar claves candidatas

1. Calcular el cierre de cada subconjunto de atributos de R.
2. Un conjunto X es clave candidata si `X⁺ = R` y ningún subconjunto propio Z de X cumple `Z⁺ = R`.

### Atributo primo vs no primo

- **Atributo primo**: aparece en **alguna** clave candidata.
- **Atributo no primo**: no aparece en ninguna clave candidata.

---

## 4. Atributos Primos y No Primos

Ejemplo con R = (A, B, C, D, E), F = {A → BC, CD → E, B → D, E → A}:

Primero hay que encontrar las claves candidatas:
- Probar A⁺: A → BC → BD (por B→D) → ... calcular sistemáticamente
- Si A⁺ = R, entonces A es superclave. Comprobar si algún subconjunto propio también lo es.

Los atributos que aparecen en alguna clave candidata son **primos**; el resto son **no primos**.

---

## 5. Recubrimiento Canónico (Fc)

### ¿Qué es?

Un **recubrimiento canónico Fc** de F es un conjunto de FD equivalente a F (mismas implicaciones lógicas, `Fc⁺ = F⁺`) que cumple tres propiedades:

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
- Si `A ∈ (X - {B})⁺`, entonces B es **ajeno** en el lado izquierdo → reemplazar `X → A` por `(X - {B}) → A`.

**Paso 3 — Eliminar FD redundantes**

Para cada FD `X → A`, comprobar si `A ∈ (F - {X→A})⁺` usando las FD restantes (es decir, calcular X⁺ sin usar esa FD).
- Si sí → la FD es redundante → eliminarla.

### Propiedades del Fc

- **Fc no es único**: puede haber varios recubrimientos canónicos de un mismo F.
- **Sí es siempre cierto**: `F⁺ = Fc⁺` (son equivalentes por definición).
- También: `Fc1⁺ = Fc2⁺` si Fc1 y Fc2 son dos recubrimientos canónicos del mismo F.
- **NO siempre se cumple** que F = Fc (como conjuntos de FD pueden diferir); lo que se cumple es `F⁺ = Fc⁺`.
- F implica lógicamente Fc (`F ⟹ Fc`) y viceversa (`Fc ⟹ F`) porque tienen el mismo cierre.

---

## 6. Atributos Ajenos (Extraños)

### En el lado derecho de `X → Y`

Un atributo A ∈ Y es **ajeno en el lado derecho** si:

> `X ⊆ (F con X → (Y - {A}))⁺`

Es decir, si quitando A del lado derecho, X todavía determina A mediante las FD restantes.

**Técnica práctica**: A ∈ Y es ajeno en el lado derecho si `A ∈ X⁺` calculado con `F' = (F - {X→Y}) ∪ {X → (Y-{A})}`.

### En el lado izquierdo de `X → Y`

Un atributo B ∈ X es **ajeno en el lado izquierdo** si:

> `Y ⊆ (X - {B})⁺` calculado bajo F

Es decir, si quitando B del lado izquierdo, el resto de X sigue determinando Y.

### Ejemplo — Pregunta 7 del primer bloque

F = { BD → CAE, CA → B, B → E }

¿Es E ajeno en BD → CAE?

Calcular BD⁺ con `F' = {BD → CA, CA → B, B → E}` (quitando E del lado derecho):
- BD⁺: inicio {B,D}
- BD → CA: {B,D,C,A}
- CA → B: B ya está
- B → E: {B,D,C,A,E}

Como E ∈ BD⁺ con F', **E sí es ajeno** en BD → CAE. ✓

¿Es C ajeno en BD → CAE?

Calcular BD⁺ con `F'' = {BD → AE, CA → B, B → E}`:
- BD⁺: {B,D}
- BD → AE: {B,D,A,E}
- CA → B: CA no ⊆ {B,D,A,E}... C sí, A sí → {B,D,A,E,B} = {A,B,D,E}
- B → E: ya está

Como C ∉ {A,B,D,E}, **C NO es ajeno** en BD → CAE.

---

## 7. Formas Normales

Las formas normales son propiedades que mide el "nivel de diseño" de un esquema relacional, principalmente para reducir la **redundancia** y las **anomalías de actualización**.

### Primera Forma Normal (1FN)

> Todos los atributos tienen dominios **atómicos** (valores indivisibles, no listas ni conjuntos).

En la teoría relacional estándar, todas las relaciones se asumen en 1FN.

### Segunda Forma Normal (2FN)

> Un esquema R está en 2FN si está en 1FN y **ningún atributo no primo depende parcialmente de una clave candidata**.

Es decir: todo atributo no primo debe depender de la clave **completa**, no de una parte de ella.

**Problema típico**: Claves candidatas compuestas donde un atributo no primo depende solo de parte de la clave.

### Tercera Forma Normal (3FN)

> Un esquema R está en 3FN si, para toda FD no trivial `X → A` en F⁺, se cumple **al menos una** de:
> 1. X es superclave de R, **o**
> 2. A es un atributo primo (pertenece a alguna clave candidata).

**Intuición**: no hay dependencias transitivas de atributos no primos a través de no-claves.

### Forma Normal de Boyce-Codd (BCNF)

> Un esquema R está en BCNF si, para toda FD no trivial `X → A` en F⁺, se cumple:
> - X es superclave de R.

BCNF es **más estricta** que 3FN: no permite la excepción del "atributo primo".

**Jerarquía**: BCNF ⊂ 3FN ⊂ 2FN ⊂ 1FN

| Forma Normal | Condición para cada FD no trivial X → A |
|---|---|
| **BCNF** | X debe ser superclave |
| **3FN** | X es superclave **O** A es primo |
| **2FN** | No hay dependencias parciales de no-primos respecto a claves candidatas |

### ¿Cómo verificar la forma normal de R?

1. Encontrar todas las claves candidatas de R.
2. Identificar atributos primos y no primos.
3. Para cada FD no trivial `X → A`:
   - Si X es superclave → cumple BCNF (y por tanto 3FN).
   - Si X no es superclave pero A es primo → cumple 3FN pero **viola BCNF**.
   - Si X no es superclave y A no es primo → **viola 3FN** (y BCNF).

### Ejemplo — Pregunta 3 del primer bloque

R = (A, B, C, D), F = { B → C, BC → DA, A → B }

**Paso 1 — Encontrar claves candidatas:**

- A⁺: A → B (→ A⁺={A,B}), B → C (→ {A,B,C}), BC → DA (→ {A,B,C,D}) = R
  → A es superclave. ¿Subconjunto propio? Ningún atributo solo da R excepto quizás A.
  → **A es clave candidata**.

- B⁺: B → C, BC → DA → B⁺ = {B,C,D,A} = R → B también es superclave.
  Subconjunto: solo B → ya vimos que funciona → **B es clave candidata**.

**Paso 2 — Atributos primos:** A y B son primos. C y D son no primos.

**Paso 3 — Verificar cada FD:**

- `B → C`: B es clave candidata → **superclave** → cumple BCNF ✓
- `BC → DA`: BC contiene a B, que es superclave → BC también es superclave → cumple BCNF ✓
- `A → B`: A es clave candidata → superclave → cumple BCNF ✓

**Conclusión**: R está en **BCNF** (la forma más alta).

> Nota importante: el enunciado dice "F no es un recubrimiento canónico" — eso es irrelevante para determinar la forma normal de R. La forma normal depende de las FD en F⁺, no de si F está en forma canónica.

### Ejemplo — Pregunta 6 del segundo bloque

R = (A, B, C, D, E), F = { A → BC, CD → E, B → D, E → A }

**Paso 1 — Claves candidatas:**

- A⁺: A→BC → {A,B,C}, B→D → {A,B,C,D}, CD→E → {A,B,C,D,E} = R → A es superclave
- E⁺: E→A → {E,A}, A→BC → {A,B,C,E}, B→D → {A,B,C,D,E} = R → E es superclave
- Buscar minimales...
  - Solo A: A⁺=R → A es clave candidata ✓
  - Solo E: E⁺=R → E es clave candidata ✓
  - ¿CD? CD→E → {C,D,E}, E→A → {A,C,D,E}, A→BC → {A,B,C,D,E} = R → CD es superclave
    - C sola: C⁺ = ? C sin más FD que partan de solo C... C→? ninguna → {C}. No.
    - D sola: D⁺ = {D}. No.
    → **CD es clave candidata** ✓

**Paso 2 — Atributos primos:** A, C, D, E son primos. B es no primo (solo aparece en A como clave candidata... espera: A={A}, E={E}, CD={C,D}). Atributos primos: A, C, D, E. **B es no primo**.

**Paso 3 — Verificar FDs:**

- A → BC: A es superclave → BCNF ✓
- CD → E: CD es superclave → BCNF ✓  
- B → D: ¿B es superclave? B⁺ = {B,D} ≠ R → NO superclave. ¿D es primo? Sí → **cumple 3FN pero viola BCNF**
- E → A: E es superclave → BCNF ✓

**Conclusión**: R está en **3FN pero no en BCNF**. La forma normal más alta es 3FN.

### Ejemplo — Pregunta 8 del segundo bloque

R = (A, B, C, D), F = { AD → C, C → D }

**Claves candidatas:**

- AD⁺: AD→C → {A,D,C}, C→D → ya D ∈. = {A,C,D}. Falta B → AD⁺ ≠ R.
- AB⁺: AB sin FDs útiles directas... A→? ninguna directa. AB⁺={A,B}. No.
- AC⁺: AC→? C→D → {A,C,D}, AD→C ya C ∈ → {A,C,D}. Falta B.
- ABC⁺: C→D → {A,B,C,D} = R → ABC es superclave. ¿Minimal? AB→? no. AC⁺={A,C,D}≠R. BC⁺: C→D → {B,C,D}≠R. → **ABC es clave candidata**
- ABD⁺: AD→C → {A,B,C,D}=R → ABD superclave. ¿Minimal? AB⁺={A,B}≠R. AD⁺={A,C,D}≠R. BD⁺={B,D}≠R. → **ABD es clave candidata**

**Atributos primos:** A, B, C, D — ¡todos son primos!

**Verificar FDs:**
- AD → C: AD⁺ = {A,C,D} ≠ R → AD no es superclave. C es primo → cumple 3FN, viola BCNF.
- C → D: C⁺ = {C,D} ≠ R → C no es superclave. D es primo → cumple 3FN, viola BCNF.

**Conclusión**: R está en **3FN pero no BCNF**. La forma normal más alta es 3FN.

---

## 8. Descomposición: PSP y Conservación de Dependencias

Cuando una relación no está en la forma normal deseada, la descomponemos en relaciones más pequeñas. Queremos que la descomposición sea "buena" en dos sentidos:

### 8.1 Propiedad de Producto Sin Pérdida (PSP / Lossless Join)

Una descomposición de R en R₁ y R₂ es **sin pérdida (lossless)** si, para toda instancia válida r(R):

> `r = πR₁(r) ⋈ πR₂(r)`

Es decir, la reunión natural de las proyecciones recupera exactamente la relación original — **sin tuplas espurias**.

**Condición para PSP en descomposición binaria** (teorema de Heath):

La descomposición {R₁, R₂} de R es sin pérdida bajo F si y solo si:

- `(R₁ ∩ R₂) → R₁` está en F⁺, **o**
- `(R₁ ∩ R₂) → R₂` está en F⁺

Es decir: los atributos comunes deben ser superclave de al menos una de las dos partes.

**Consecuencias importantes:**

- Si R₁ y R₂ no comparten ningún atributo en común → la descomposición **nunca es sin pérdida** (la reunión daría el producto cartesiano).
- Tener atributos comunes es **necesario** pero **no suficiente** — hay que verificar la condición de Heath.
- `πR₁(r) ⋈ πR₂(r)` siempre contiene al menos las tuplas de r (puede tener más → eso son las espurias).

**Por qué es importante**: Si no se cumple PSP, al reconstruir la relación original desde las partes obtenemos información falsa (tuplas que no existían). No podemos recuperar fielmente la información original.

### 8.2 Conservación de Dependencias (CD)

Una descomposición {R₁, R₂, ..., Rₙ} de R **conserva las dependencias** si:

> `(F₁ ∪ F₂ ∪ ... ∪ Fₙ)⁺ = F⁺`

donde Fᵢ es la proyección de F sobre Rᵢ: `Fᵢ = { X → Y ∈ F⁺ | X ∪ Y ⊆ Rᵢ }`

**¿Por qué es deseable?**

Si se conservan las dependencias, podemos **verificar cada restricción (FD) comprobando solo una de las relaciones de la descomposición**, sin necesidad de hacer joins. Si no se conservan, habría que reunir relaciones para comprobar si una FD se viola, lo cual es costoso y complicado.

**¿Qué NO implica la conservación de dependencias?**

- No implica PSP (se pueden perder tuplas igualmente).
- No garantiza BCNF en todas las partes (de hecho, no siempre es posible tener a la vez BCNF y conservar dependencias).
- No evita que la BD quede inconsistente por si sola — simplemente facilita la verificación de restricciones.

**Relación entre PSP y CD:**

| | PSP | CD |
|---|---|---|
| BCNF | Siempre posible | No siempre posible |
| 3FN | Siempre posible | Siempre posible |

Por eso se usa 3FN como compromiso: permite siempre PSP + CD juntos.

---

## 9. Integridad Referencial

### Definición

Dada una **relación referenciada r₁** con clave primaria K, y una **relación que referencia r₂** con clave externa α (que referencia a K):

> La **integridad referencial** exige que todo valor de α en r₂ aparezca como valor de K en r₁.

Formalmente:

> **Πα(r₂) ⊆ ΠK(r₁)**

Esta condición **siempre debe cumplirse** en un estado consistente de la BD.

**Nota sobre la dirección de la condición**: es `Πα(r₂) ⊆ ΠK(r₁)`, no al revés. r₁ puede tener valores en K que no aparezcan en r₂ (eso está permitido). Lo que NO puede ocurrir es que r₂ tenga un valor en α que no exista en K de r₁.

### Restricciones en modificaciones

| Operación | Relación | ¿Puede desencadenar acción? |
|-----------|----------|---------------------------|
| **Inserción** en r₂ | referenciante | Sí → se verifica que el nuevo α ∈ ΠK(r₁); si no → error o rechazo |
| **Eliminación** en r₁ | referenciada | Sí → si la tupla eliminada tiene K referenciado por algún α de r₂ |
| **Actualización** en r₁ | referenciada | Sí → si se cambia K que está referenciado por r₂ |
| **Inserción** en r₁ | referenciada | No desencadena acciones en r₂ |
| **Eliminación** en r₂ | referenciante | No desencadena acciones en r₁ |
| **Actualización** en r₂ | referenciante | Puede requerir verificar que el nuevo α exista en K de r₁ |

### Acciones al violar la integridad referencial

Cuando se elimina o actualiza una tupla de r₁ cuyo K está referenciado por r₂:

| Política | Efecto |
|----------|--------|
| **CASCADE** | Eliminar/actualizar las tuplas correspondientes en r₂ |
| **SET NULL** | Poner α = NULL en las tuplas de r₂ |
| **SET DEFAULT** | Poner α = valor por defecto |
| **RESTRICT / NO ACTION** | Rechazar la operación |

**Resumen clave para el examen:**

- Eliminación en **r₁** → puede provocar **eliminación** (CASCADE) o **actualización** (SET NULL) en **r₂**.
- Actualización de K en **r₁** → puede provocar **actualización** de α en **r₂** (CASCADE).
- Inserción en **r₂** → se verifica contra r₁ (si el α no existe en K de r₁ → error).
- Inserción en **r₁** → **nunca** desencadena nada en r₂.
- Eliminación en **r₂** → **nunca** afecta a r₁.

**¿Requiere r₁ estar en BCNF?** No. La integridad referencial no impone ninguna forma normal sobre r₁ ni r₂.

**¿Deben ser relaciones compatibles para la diferencia?** No. Eso es un concepto del álgebra relacional para operaciones de conjunto, no de integridad referencial.

---

## 10. Álgebra Relacional

### Operaciones fundamentales (básicas)

Las operaciones que forman el conjunto **mínimo completo** del álgebra relacional son:

| Operación | Símbolo | Descripción |
|-----------|---------|-------------|
| **Selección** | σ | Filtra tuplas que cumplen una condición |
| **Proyección** | π | Selecciona columnas (atributos) |
| **Unión** | ∪ | Tuplas en r₁ o r₂ (requieren compatibilidad) |
| **Diferencia** | − | Tuplas en r₁ que no están en r₂ |
| **Producto cartesiano** | × | Combina todas las tuplas de r₁ con r₂ |
| **Renombramiento** | ρ | Renombra la relación o sus atributos |

Operaciones **derivadas** (no básicas, se expresan en términos de las anteriores):

| Operación | Cómo se deriva |
|-----------|---------------|
| **Intersección** (∩) | `r ∩ s = r − (r − s)` |
| **Reunión natural** (⋈) | Combinación de ×, σ, π |
| **División** (÷) | Combinación de π, ×, − |
| **Semireunión** | Derivada de ⋈ y π |

### Intersección en SQL

La intersección del álgebra relacional (`r ∩ s`) se puede expresar en SQL de varias formas:
- `r INTERSECT s` (si el SGBD lo soporta)
- Mediante `EXISTS`: `SELECT * FROM r WHERE EXISTS (SELECT * FROM s WHERE r.attr = s.attr)`
- Mediante `IN`: `SELECT * FROM r WHERE attr IN (SELECT attr FROM s)`

**No** es cierto que no pueda expresarse. Tampoco requiere obligatoriamente MINUS/EXCEPT ni FORALL.

### División relacional en SQL

La división `r ÷ s` (encontrar qué valores de r se relacionan con **todos** los valores de s) se expresa con doble NOT EXISTS:

```sql
SELECT DISTINCT x FROM r AS r1
WHERE NOT EXISTS (
  SELECT * FROM s
  WHERE NOT EXISTS (
    SELECT * FROM r AS r2
    WHERE r2.x = r1.x AND r2.y = s.y
  )
);
```

---

## 11. SQL — Restricciones de Integridad

### Restricciones disponibles en SQL2 (SQL-92)

| Restricción | Cláusula SQL |
|-------------|-------------|
| **Clave primaria** | `PRIMARY KEY` |
| **Clave candidata / unicidad** | `UNIQUE` |
| **Clave externa** | `FOREIGN KEY ... REFERENCES ...` |
| **Restricción de dominio** | `CHECK (condición)` |
| **No nulo** | `NOT NULL` |
| **Asertos globales** | `CREATE ASSERTION nombre CHECK (condición)` |

**Puntos clave:**

- Las claves candidatas se expresan con `UNIQUE`, **no** con `FOREIGN KEY`.
- Las claves primarias se expresan con `PRIMARY KEY`, **no** con `FOREIGN KEY`.
- Los **asertos** (`CREATE ASSERTION`) permiten restricciones que afectan a toda la base de datos o a varias tablas, no solo a una fila.
- Los **disparadores** (triggers) se crean con `CREATE TRIGGER`, no con `CREATE ASSERTION`.
- Las **dependencias funcionales** no son expresables directamente en SQL estándar.

### Ejemplo de CREATE ASSERTION

```sql
CREATE ASSERTION sueldo_valido
CHECK (NOT EXISTS (
  SELECT * FROM empleado
  WHERE sueldo > (SELECT MAX(sueldo) FROM directivo)
));
```

---

## 12. Resumen Rápido de las Preguntas

### Bloque 1 — Preguntas tipo test

| Preg. | Respuesta correcta | Concepto |
|-------|-------------------|----------|
| 1 | **(e)** Siempre debe cumplirse Πα(r₂) ⊆ ΠK(r₁) | Integridad referencial |
| 2 | **(e)** F ⟹ Fc y Fc ⟹ F (equivalentes, mismo F⁺) | Recubrimiento canónico |
| 3 | **(e)** La forma normal más alta es BCNF | Forma normal (ver cálculo arriba) |
| 4 | **(d)** Ninguna de las otras es correcta | PSP: R₁∩R₂ puede ser vacío solo si no hay PSP; el join puede tener más tuplas |
| 5 | **(e)** Ninguna de las otras es correcta | La conservación facilita verificar FDs sin joins |
| 6 | **(a)** Ninguna de las otras (o **(b)** según versión) | SQL: UNIQUE para candidatas |
| 7 | **(a)** E es ajeno en BD → CAE | Atributo ajeno (ver cálculo arriba) |
| 8 | **(e)** Ninguna de las otras es correcta | Intersección sí expresable en SQL |
| 9 | **(e)** Ninguna de las otras es correcta | X⁺ siempre tiene ≥ atributos que X; no necesita Fc |
| 10 | **(a)** Eliminación en r₁ puede provocar eliminación en r₂ | Integridad referencial — cascada |

**Notas sobre Pregunta 4 (PSP):**
- (a) Falso: si R₁∩R₂=∅ → siempre pérdida (resultado sería producto cartesiano).
- (b) Falso: no hay límite de un atributo en común.
- (c) Falso: tener >1 atributo común no garantiza PSP; hay que verificar la condición de Heath.
- (e) Falso: `πR₁(r) ⋈ πR₂(r)` **puede** tener más tuplas que r (las espurias).
- → La (d) es correcta.

**Notas sobre Pregunta 9 (X⁺):**
- (a) Falso: se puede calcular desde F directamente, no necesita Fc.
- (b) Falso: X⁺ siempre contiene X, nunca menos atributos que X.
- (c) Falso: no hay implicación directa entre atributos primos de X y de X⁺.
- (d) Falso: que X tenga todos atributos primos no implica X⁺=R.
- → La (e) "Ninguna de las otras" es correcta.

### Bloque 2 — Preguntas de verdadero/identificación

| Preg. | Respuesta | Concepto |
|-------|-----------|---------|
| 1a | **Verdadero** | F solo da n_editorial; precio y múltiples autores no están determinados por n_libro sola |
| 2a | **Verdadero** | CREATE ASSERTION existe en SQL2 para asertos |
| 3a | **Verdadero** | Fc1⁺ = F⁺ = Fc2⁺ siempre |
| 4a | **Verdadero** | Actualización en r₁ (CASCADE en K) → actualización de α en r₂ |
| 5a | **Verdadero** | Selección, Unión, Diferencia son básicas (también lo son ×, π, ρ) |
| 6a | **Verdadero** | R está en 3FN (por B→D: B no es superclave, D no es primo → viola BCNF; pero cumple 3FN) |
| 7a/7b | **Verdadero** | B es ajeno en ADE→BCD: calcular ADE⁺ sin B en el lado derecho |
| 8a | **Verdadero** | R está en 3FN (ver cálculo arriba) |
| 9a | **Verdadero** | Sin PSP no se puede reconstruir fielmente la información original |
| 10a | **Verdadero** | Πα(r₂) ⊆ ΠK(r₁) siempre debe cumplirse |

---

## Apéndice: Cálculos detallados adicionales

### Pregunta 1 del bloque 2 — R = (n_autor, n_libro, n_editorial, precio), F = {n_autor, n_libro → n_editorial}

**Clave candidata**: La FD dice que (n_autor, n_libro) determina n_editorial. ¿Pero determina precio? No hay ninguna FD que lo diga. Por lo tanto:

- Distintas tuplas con el mismo (n_autor, n_libro) podrían tener distintos precios → (n_autor, n_libro) no determina precio.
- Esto significa que la clave candidata debe incluir también precio, o hay múltiples tuplas por (n_autor, n_libro).

La afirmación "un mismo libro puede tener varios autores y precios diferentes" es **verdadera** porque:
- Varios autores → n_autor varía → combinaciones (n_autor, n_libro) distintas para el mismo n_libro.
- Precios diferentes → no hay FD que fije el precio según el autor y libro.

### Pregunta 7 del bloque 2 — F = {ADE → BCD, CD → AB}

¿Es B ajeno en ADE → BCD?

Calcular ADE⁺ con F' = {ADE → CD, CD → AB} (quitando B del lado derecho de la primera):
- ADE⁺: inicio {A,D,E}
- ADE → CD: → {A,C,D,E}
- CD → AB: CD ⊆ {A,C,D,E} ✓ → {A,B,C,D,E}

B ∈ {A,B,C,D,E} → **B sí es ajeno** en ADE → BCD. ✓

---

*Guía generada para preparación de examen de Teoría de Bases de Datos*
*Cubre: dependencias funcionales, cierres, recubrimiento canónico, formas normales (3FN/BCNF), descomposición (PSP/CD), integridad referencial, álgebra relacional, SQL2*
