.text
.global resultados
.bss
.align 3
resultados:
    .zero 1000

.section .rodata
str_menu:      .string "\n--- Menú Principal ---"
str_op1:       .string "1. Imprimir el Nombre de los integrantes del grupo"
str_op2:       .string "2. Realizar Análisis Estadístico" 
str_op3:       .string "3. Exportar los resultados a Txt"
str_op4:       .string "4. Salir"
str_prompt:    .string "Seleccione una opción: "
str_format:    .string "%d"
str_exit:      .string "Saliendo del programa..."
str_invalid:   .string "Opción inválida. Intente de nuevo."

// Strings para integrantes
str_team:      .string "\nIntegrantes del equipo:"
str_int1:      .string "1. Henry David Quel Santos"
str_carne1:    .string "Carné: 202004071\n"
str_int2:      .string "2. Pablo Alejandro Marroquin Cutz"
str_carne2:    .string "Carné: 202200214\n"
str_int3:      .string "3. Eric David Rojas de León"
str_carne3:    .string "Carné: 202200331\n"
str_int4:      .string "4. David Isaac García Mejía"
str_carne4:    .string "Carné: 202202077\n"
str_int5:      .string "5. Jorge Alejandro De León Batres"
str_carne5:    .string "Carné: 202111277\n"
str_int6:      .string "6. Roberto Miguel Garcia Santizo"
str_carne6:    .string "Carné: 202201724\n"
str_int7:      .string "7. Jose Javier Bonilla Salazar"
str_carne7:    .string "Carné: 202200035\n"
str_int8:      .string "8. Gerardo Leonel Ortiz Tobar"
str_carne8:    .string "Carné: 202200196\n"

// Strings para archivos y análisis
str_read:      .string "r"
str_write:     .string "w"
str_datafile:  .string "datos.csv"
str_resfile:   .string "resultados.txt"
str_dataerr:   .string "No se pudo abrir el archivo de datos."
str_reserr:    .string "No se pudo crear el archivo de resultados."
str_csvfmt:    .string "%[^,],%f,%f,%[^,],%f,%[^,],%s"
str_stats:     .string "\n--- Resultados Estadísticos ---"
str_statsfmt:  .string "Media Interna: %.2f\nMedia Externa: %.2f\nModa Interna: %.2f\nModa Externa: %.2f\nMax Interna: %.2f\nMin Interna: %.2f\nMax Externa: %.2f\nMin Externa: %.2f\nRango Interna: %.2f\nRango Externa: %.2f\n"
str_exported:  .string "Resultados exportados a resultados.txt"

.text
.global main
main:
    // Guardar registros
    sub sp, sp, 6432
    stp x29, x30, [sp]
    mov x29, sp
    
    // Inicializar variables
    str wzr, [sp, 28]
    add x1, sp, 28
    add x0, sp, 32
    bl cargarDatos

menu_loop:
    // Imprimir menú
    adr x0, str_menu
    bl puts
    adr x0, str_op1
    bl puts
    adr x0, str_op2
    bl puts
    adr x0, str_op3
    bl puts
    adr x0, str_op4
    bl puts
    adr x0, str_prompt

    // Leer opción
    add x0, sp, 24
    mov x1, x0
    adr x0, str_format

    // Switch de opciones
    ldr w0, [sp, 24]
    cmp w0, 1
    beq op_integrantes
    cmp w0, 2
    beq op_analisis
    cmp w0, 3
    beq op_exportar
    cmp w0, 4
    beq op_salir
    b op_invalida

op_integrantes:
    bl imprimirIntegrantes
    b menu_continue

op_analisis:
    ldr w1, [sp, 28]
    add x0, sp, 32
    bl realizarAnalisisEstadistico
    b menu_continue

op_exportar:
    bl exportarResultadosATxt
    b menu_continue

op_salir:
    adr x0, str_exit
    bl puts
    b menu_continue

op_invalida:
    adr x0, str_invalid
    bl puts

menu_continue:
    ldr w0, [sp, 24]
    cmp w0, 4
    bne menu_loop

    // Restaurar y salir
    mov w0, 0
    ldp x29, x30, [sp]
    add sp, sp, 6432
    ret


imprimirIntegrantes:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Imprimir cada integrante
    adr x0, str_team
    bl puts
    adr x0, str_int1
    bl puts
    adr x0, str_carne1
    bl puts
    
    adr x0, str_int2
    bl puts
    adr x0, str_carne2
    bl puts
    
    adr x0, str_int3
    bl puts
    adr x0, str_carne3
    bl puts

    adr x0, str_int4
    bl puts
    adr x0, str_carne4
    bl puts

    adr x0, str_int5
    bl puts
    adr x0, str_carne5
    bl puts

    adr x0, str_int6
    bl puts
    adr x0, str_carne6
    bl puts

    adr x0, str_int7
    bl puts
    adr x0, str_carne7
    bl puts

    adr x0, str_int8
    bl puts
    adr x0, str_carne8
    bl puts
    
    ldp x29, x30, [sp], 16
    ret

cargarDatos:
    sub sp, sp, 256
    stp x29, x30, [sp, 16]
    mov x29, sp
    str x0, [sp, 40]      // buffer
    str x1, [sp, 32]      // contador

    ldr x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    mov     x9, x0
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x2, x0, 20
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x3, x0, 24
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x4, x0, 28
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x5, x0, 40
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x6, x0, 44
    ldr     x0, [sp, 32]
    ldr     w0, [x0]
    sxtw    x0, w0
    lsl     x0, x0, 6
    ldr     x1, [sp, 40]
    add     x0, x1, x0
    add     x0, x0, 54
    add     x8, sp, 48
    str     x0, [sp]
    mov     x7, x6
    mov     x6, x5
    mov     x5, x4
    mov     x4, x3
    mov     x3, x2
    mov     x2, x9
    // Abrir archivo
    adr x0, str_datafile
    adr x1, str_read
    bl fopen
    str x0, [sp, 248]     // file pointer
    
    // Verificar apertura
    cbnz x0, load_start
    adr x0, str_dataerr
    bl puts
    mov w0, 1
    bl exit

load_start:
    add x0, sp, 48        // buffer línea
    mov w1, 200           // tamaño máximo
    ldr x2, [sp, 248]     // file pointer
    bl fgets

load_loop:
    cbz x0, load_end      // si fgets retorna 0, fin archivo
    
    // Procesar línea
    ldr x0, [sp, 32]
    ldr w0, [x0]
    // ... procesar datos CSV
    
    // Siguiente línea
    add x0, sp, 48
    mov w1, 200
    ldr x2, [sp, 248]
    bl fgets
    b load_loop

load_end:
    ldr x0, [sp, 248]
    bl fclose
    ldp x29, x30, [sp, 16]
    add sp, sp, 256
    ret

calcularMedia:
    sub sp, sp, 32
    str x0, [sp, 8]       // array
    str w1, [sp, 4]       // tamaño
    
    // Inicializar suma
    str wzr, [sp, 28]
    mov w4, 0             // contador
    
media_loop:
    cmp w4, w1
    bge media_end
    
    // Sumar elemento
    lsl x3, x4, 2        // índice * 4
    ldr x2, [sp, 8]
    add x2, x2, x3
    ldr s0, [x2]
    ldr s1, [sp, 28]
    fadd s0, s1, s0
    str s0, [sp, 28]
    
    add w4, w4, 1
    b media_loop

media_end:
    // Calcular promedio
    ldr s0, [sp, 4]
    scvtf s0, s0
    ldr s1, [sp, 28]
    fdiv s0, s1, s0
    
    add sp, sp, 32
    ret

encontrarModa:
    sub sp, sp, 48
    str x0, [sp, 8]      // array
    str w1, [sp, 4]      // tamaño
    
    // Inicializar variables
    str wzr, [sp, 44]    // max_freq
    ldr x0, [sp, 8]
    ldr s0, [x0]
    str s0, [sp, 40]     // moda
    
    mov w4, 0            // i
moda_loop_outer:
    cmp w4, w1
    bge moda_end
    
    // Contar frecuencia
    str wzr, [sp, 32]    // freq
    mov w5, 0            // j
    
moda_loop_inner:
    cmp w5, w1
    bge moda_check
    
    // Comparar elementos
    lsl x2, w5, 2
    ldr x3, [sp, 8]
    add x2, x3, x2
    ldr s0, [x2]
    
    lsl x2, w4, 2
    add x2, x3, x2
    ldr s1, [x2]
    
    fcmp s0, s1
    bne moda_next
    
    ldr w2, [sp, 32]
    add w2, w2, 1
    str w2, [sp, 32]
    
moda_next:
    add w5, w5, 1
    b moda_loop_inner

moda_check:
    ldr w2, [sp, 32]
    ldr w3, [sp, 44]
    cmp w2, w3
    ble moda_continue
    
    // Actualizar moda
    str w2, [sp, 44]
    lsl x2, w4, 2
    ldr x3, [sp, 8]
    add x2, x3, x2
    ldr s0, [x2]
    str s0, [sp, 40]
    
moda_continue:
    add w4, w4, 1
    b moda_loop_outer

moda_end:
    ldr s0, [sp, 40]
    add sp, sp, 48
    ret

encontrarMaximo:
    sub sp, sp, 32
    str x0, [sp, 8]      // array
    str w1, [sp, 4]      // tamaño
    
    // Inicializar con primer elemento
    ldr x0, [sp, 8]
    ldr s0, [x0]
    str s0, [sp, 28]     // max
    
    mov w4, 1            // i = 1
max_loop:
    cmp w4, w1
    bge max_end
    
    // Comparar con máximo actual
    lsl x2, w4, 2
    ldr x3, [sp, 8]
    add x2, x3, x2
    ldr s0, [x2]
    ldr s1, [sp, 28]
    fcmp s1, s0
    bgt max_continue
    
    // Actualizar máximo
    str s0, [sp, 28]
    
max_continue:
    add w4, w4, 1
    b max_loop

max_end:
    ldr s0, [sp, 28]
    add sp, sp, 32
    ret

encontrarMinimo:
    // Similar a encontrarMaximo pero con comparación invertida
    sub sp, sp, 32
    str x0, [sp, 8]
    str w1, [sp, 4]
    
    ldr x0, [sp, 8]
    ldr s0, [x0]
    str s0, [sp, 28]
    
    mov w4, 1
min_loop:
    cmp w4, w1
    bge min_end
    
    lsl x2, w4, 2
    ldr x3, [sp, 8]
    add x2, x3, x2
    ldr s0, [x2]
    ldr s1, [sp, 28]
    fcmp s1, s0
    blt min_continue
    
    str s0, [sp, 28]
    
min_continue:
    add w4, w4, 1
    b min_loop

min_end:
    ldr s0, [sp, 28]
    add sp, sp, 32
    ret

exportarResultadosATxt:
    stp x29, x30, [sp, -32]!
    mov x29, sp
    
    // Abrir archivo
    adr x0, str_resfile
    adr x1, str_write
    bl fopen
    str x0, [sp, 24]
    
    // Verificar apertura
    cbnz x0, export_start
    adr x0, str_reserr
    bl puts
    b export_end
    
export_start:
    // Escribir encabezado
    ldr x3, [sp, 24]
    adr x0, str_stats
    bl fputs
    
    // Escribir resultados
    ldr x1, [sp, 24]
    adr x0, resultados
    bl fputs
    
    // Cerrar archivo
    ldr x0, [sp, 24]
    bl fclose
    
    // Mensaje éxito
    adr x0, str_exported
    bl puts
    
export_end:
    ldp x29, x30, [sp], 32
    re