.data
// Mode-related
    outfile_mode: .asciz "modas.txt"
    
    msg_mode_temp_int: .asciz "Moda Temperatura Interna: "
    msg_mode_temp_int_len = . - msg_mode_temp_int
    
    msg_mode_temp_ext: .asciz "Moda Temperatura Externa: "
    msg_mode_temp_ext_len = . - msg_mode_temp_ext
    
    msg_mode_nivel: .asciz "Moda Nivel de Agua: "
    msg_mode_nivel_len = . - msg_mode_nivel
    
    mode_temp_int: .double 0.0
    mode_temp_ext: .double 0.0
    mode_nivel: .double 0.0
    
    out_mode_temp_int: .skip 32
    out_mode_temp_ext: .skip 32
    out_mode_nivel: .skip 32
    // Nuevas variables para rangos
    outfile_range: .asciz "rangos.txt"
    
    msg_range_temp_int: .asciz "Rango Temperatura Interna: "
    msg_range_temp_int_len = . - msg_range_temp_int
    
    msg_range_temp_ext: .asciz "Rango Temperatura Externa: "
    msg_range_temp_ext_len = . - msg_range_temp_ext
    
    msg_range_nivel: .asciz "Rango Nivel de Agua: "
    msg_range_nivel_len = . - msg_range_nivel
    
    // Variables para almacenar rangos
    range_temp_int: .double 0.0
    range_temp_ext: .double 0.0
    range_nivel: .double 0.0
    
    // Buffers para strings de rangos
    out_range_temp_int: .skip 32
    out_range_temp_ext: .skip 32
    out_range_nivel: .skip 32

    outfile_maxmin: .asciz "maxmin.txt"
    
    msg_max_temp_int: .asciz "Temperatura Interna Máxima: "
    msg_max_temp_int_len = . - msg_max_temp_int
    
    msg_min_temp_int: .asciz "Temperatura Interna Mínima: "
    msg_min_temp_int_len = . - msg_min_temp_int
    
    msg_max_temp_ext: .asciz "Temperatura Externa Máxima: "
    msg_max_temp_ext_len = . - msg_max_temp_ext
    
    msg_min_temp_ext: .asciz "Temperatura Externa Mínima: "
    msg_min_temp_ext_len = . - msg_min_temp_ext
    
    msg_max_nivel: .asciz "Nivel de Agua Máximo: "
    msg_max_nivel_len = . - msg_max_nivel
    
    msg_min_nivel: .asciz "Nivel de Agua Mínimo: "
    msg_min_nivel_len = . - msg_min_nivel
    
    // Variables para almacenar máximos y mínimos
    max_temp_int: .double 0.0
    min_temp_int: .double 0.0
    max_temp_ext: .double 0.0
    min_temp_ext: .double 0.0
    max_nivel: .double 0.0
    min_nivel: .double 0.0
    
    // Buffers para strings de máximos y mínimos
    out_max_temp_int: .skip 32
    out_min_temp_int: .skip 32
    out_max_temp_ext: .skip 32
    out_min_temp_ext: .skip 32
    out_max_nivel: .skip 32
    out_min_nivel: .skip 32

    // Add these to your .data section
    menu_msg:    .string "\n=== MENU PRINCIPAL ===\n\n1. Mostrar integrantes\n2. Analisis estadistico\n3. Generar archivos TXT\n4. Salir\n\nIngrese su opcion: "
    menu_msg_len = . - menu_msg

    input_buffer: .skip 2      // Buffer para la entrada del usuario
    newline_str: .string "\n"

    nombres:    .string "\nIntegrantes del grupo:\n\n1. Henry David Quel Santos - 202004071\n2. Pablo Alejandro Marroquin Cutz - 202200214\n3. Eric David Rojas de Leon - 202200331\n4. Jore Alejandro de Leon Batres - 202111277\n5. Roberto Miguel Garcia Santizo - 202201724\n6. Jose Javier Bonilla Salazar - 202200035\n7. Gerardo Leonel Ortiz Tobar - 202200196\n8. David Isaac García Mejía - 202202077\n\n"
    nombres_len = . - nombres

    // New constants and variables for median calculation
    outfile_median: .asciz "medianas.txt"
    
    msg_med_temp_int: .asciz "Mediana Temperatura Interna: "
    msg_med_temp_int_len = . - msg_med_temp_int
    
    msg_med_temp_ext: .asciz "Mediana Temperatura Externa: "
    msg_med_temp_ext_len = . - msg_med_temp_ext
    
    msg_med_nivel: .asciz "Mediana Nivel de Agua: "
    msg_med_nivel_len = . - msg_med_nivel
    
    // Buffers for sorted arrays (5 entries x 8 bytes each)
    temp_interna_sorted: .skip 40
    temp_externa_sorted: .skip 40
    nivel_agua_sorted: .skip 40
    
    // Medianas
    median_temp_int: .double 0.0
    median_temp_ext: .double 0.0
    median_nivel: .double 0.0
    
    // Buffers para strings de medianas
    out_med_temp_int: .skip 32
    out_med_temp_ext: .skip 32
    out_med_nivel: .skip 32
    
    const_two: .double 2.0

    // Constantes adicionales para double_to_string
    const_zero: .double 0.0
    const_hundred: .double 100.0
    digit_table: .asciz "0123456789"
    temp_buffer: .skip 32
    decimal_point: .asciz "."

    msg_temp_int: .asciz "Promedio Temperatura Interna: "
    msg_temp_int_len = . - msg_temp_int


    msg_temp_ext: .asciz "Promedio Temperatura Externa: "
    msg_temp_ext_len = . - msg_temp_ext
    
    msg_nivel: .asciz "Promedio Nivel de Agua: "
    msg_nivel_len = . - msg_nivel
    
    newline: .asciz "\n"
    newline_len = . - newline

    FILE_PERMS = 0644    // rw-r--r--
    O_CREAT = 64         // Valor decimal para O_CREAT
    O_RDWR = 2          // Valor decimal para O_RDWR

    // Archivos
    filename: .asciz "datos.csv"
    outfile: .asciz "promedios.txt"
    
    // Buffers
    buffer: .skip 2048
    
    // Arrays para datos (5 entradas x 8 bytes cada una)
    temp_interna: .skip 40
    temp_externa: .skip 40
    nivel_agua: .skip 40
    
    // Promedios
    avg_temp_int: .double 0.0
    avg_temp_ext: .double 0.0
    avg_nivel: .double 0.0
    
    // Constantes
    const_ten: .double 10.0
    const_point_one: .double 0.1
    const_five: .double 5.0    // Para dividir por 5 (promedio)
    
    // Mensajes
    msg_error: .asciz "Error al abrir archivo\n"
    msg_success: .asciz "Datos leídos correctamente\n"
    
    // Formato para el archivo de salida
    out_format: .ascii "Promedio Temperatura Interna: "
    out_temp_int: .skip 32
    out_newline1: .ascii "\nPromedio Temperatura Externa: "
    out_temp_ext: .skip 32
    out_newline2: .ascii "\nPromedio Nivel de Agua: "
    out_nivel: .skip 32
    out_newline3: .ascii "\n"
    
    // Variables temporales
    .align 4
    fd: .word 0
    outfd: .word 0

.text
.global _start

_start:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

menu_loop:
    // Mostrar menu
    mov x0, #1              // stdout
    adr x1, menu_msg        // mensaje del menu
    mov x2, menu_msg_len    // longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    // Leer opción del usuario
    mov x0, #0              // stdin
    adr x1, input_buffer    // buffer para entrada
    mov x2, #2              // leer 2 bytes (1 para el número, 1 para newline)
    mov x8, #63             // syscall read
    svc #0

    // Convertir ASCII a número
    ldrb w0, [x1]
    sub w0, w0, #'0'

    // Comparar opción
    cmp w0, #1
    b.eq show_names
    cmp w0, #2
    b.eq do_analysis
    cmp w0, #3
    b.eq generate_txt
    cmp w0, #4
    b.eq exit_program

    b menu_loop            // Si no es una opción válida, volver a mostrar menú

show_names:
    // Mostrar nombres de integrantes
    mov x0, #1
    adr x1, nombres
    mov x2, nombres_len
    mov x8, #64
    svc #0
    b menu_loop

generate_txt:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    bl write_to_file
    bl write_medians_to_file
    bl write_maxmin_to_file
    bl write_ranges_to_file
    bl write_modes_to_file

    ldp x29, x30, [sp], #16
    b menu_loop

exit_program:
    mov x0, #0
    mov x8, #93            // exit syscall
    svc #0

    // Abrir archivo

    
// Función para calcular promedios
calculate_averages:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Inicializar sumatorias
    fmov d3, xzr          // suma temp_interna
    fmov d4, xzr          // suma temp_externa
    fmov d5, xzr          // suma nivel_agua
    
    mov x0, #0            // contador
    
sum_loop:
    cmp x0, #5
    b.ge end_sum
    
    // Sumar temperatura interna
    adr x1, temp_interna
    ldr d1, [x1, x0, lsl #3]
    fadd d3, d3, d1
    
    // Sumar temperatura externa
    adr x1, temp_externa
    ldr d1, [x1, x0, lsl #3]
    fadd d4, d4, d1
    
    // Sumar nivel de agua
    adr x1, nivel_agua
    ldr d1, [x1, x0, lsl #3]
    fadd d5, d5, d1
    
    add x0, x0, #1
    b sum_loop
    
end_sum:
    // Dividir por 5 para obtener promedios
    adr x0, const_five
    ldr d6, [x0]
    
    fdiv d3, d3, d6
    fdiv d4, d4, d6
    fdiv d5, d5, d6
    
    // Guardar promedios
    adr x0, avg_temp_int
    str d3, [x0]
    adr x0, avg_temp_ext
    str d4, [x0]
    adr x0, avg_nivel
    str d5, [x0]
    
    ldp x29, x30, [sp], #16
    ret

// Función para convertir números a texto
convert_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Convertir temperatura interna
    adr x0, avg_temp_int
    ldr d0, [x0]
    adr x0, out_temp_int
    bl double_to_string
    
    // Convertir temperatura externa
    adr x0, avg_temp_ext
    ldr d0, [x0]
    adr x0, out_temp_ext
    bl double_to_string
    
    // Convertir nivel de agua
    adr x0, avg_nivel
    ldr d0, [x0]
    adr x0, out_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

// Función para escribir a archivo
write_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Crear archivo de salida
    mov x0, #-100
    adr x1, outfile
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_error
    
    mov x19, x0           // Guardar fd

    // Truncar el archivo a longitud 0
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46           // ftruncate
    svc #0
    
    // Escribir temperatura interna
    mov x0, x19
    adr x1, msg_temp_int
    mov x2, msg_temp_int_len
    mov x8, #64           // write
    svc #0
    
    mov x0, x19
    adr x1, out_temp_int
    mov x2, #32           // longitud máxima
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir temperatura externa
    mov x0, x19
    adr x1, msg_temp_ext
    mov x2, msg_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir nivel de agua
    mov x0, x19
    adr x1, msg_nivel
    mov x2, msg_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Cerrar archivo
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_done

write_error:
    mov x0, #1

write_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
// Función auxiliar para convertir double a string
double_to_string:
    stp x29, x30, [sp, -64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    
    mov x19, x0              // Guardar puntero al buffer destino
    fmov d8, d0              // Guardar número original
    
    // Verificar si el número es negativo
    adr x0, const_zero
    ldr d1, [x0]
    fcmp d8, d1
    b.ge positive_number
    
    // Si es negativo, escribir '-' y hacer el número positivo
    mov w0, #'-'
    strb w0, [x19], #1
    fneg d8, d8
    
positive_number:
    // Multiplicar por 100 para manejar 2 decimales
    adr x0, const_hundred
    ldr d1, [x0]
    fmul d9, d8, d1
    
    // Convertir a entero
    fcvtzs x20, d9          // x20 contiene el número * 100
    
    // Preparar para la conversión
    mov x21, x19            // Usar directamente el buffer de salida
    mov x22, #0             // Contador de dígitos
    
    // Procesar los dos decimales primero
    mov x1, #10
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    
    mov x20, x2
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    
    // Agregar punto decimal
    mov w0, #'.'
    strb w0, [x21, x22]
    add x22, x22, #1
    
    mov x20, x2
    
    
    // Procesar parte entera
process_integer:
    cbz x20, check_zero
    mov x1, #10
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    mov x20, x2
    b process_integer

check_zero:
    cmp x22, #3             // Solo punto y decimales
    b.ne reverse_string
    mov w0, #'0'
    strb w0, [x21, x22]
    add x22, x22, #1

reverse_string:
    // Revertir los caracteres
    mov x0, x19             // Inicio
    sub x1, x21, #1         // Fin
    add x1, x1, x22

reverse_loop:
    cmp x0, x1
    b.ge done_reverse
    ldrb w2, [x0]
    ldrb w3, [x1]
    strb w2, [x1]
    strb w3, [x0]
    add x0, x0, #1
    sub x1, x1, #1
    b reverse_loop
    
done_reverse:
    // Agregar terminador nulo
    add x0, x19, x22
    mov w1, #0
    strb w1, [x0]
    
    mov x0, x22             // Devolver longitud
    
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret
    
end_conversion:
    // Si no procesamos ningún dígito entero, poner un 0
    cmp x21, x22
    b.eq write_zero
    
copy_to_output:
    // Copiar los dígitos al buffer final en orden inverso
    mov x0, x19             // Destino
    sub x21, x21, #1        // Último dígito escrito

copy_loop:
    cmp x21, x22
    b.lt done_copy
    ldrb w1, [x21], #-1
    strb w1, [x0], #1
    b copy_loop
    
write_zero:
    mov w0, #'0'
    strb w0, [x19], #1
    
done_copy:
    // Terminar string con null
    mov w0, #0
    strb w0, [x19]
    
    // Calcular y devolver la longitud
    sub x0, x19, x20        // Longitud = posición final - posición inicial
    
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret


exit:
    ldp x29, x30, [sp], #16
    mov x8, #93            // exit
    svc #0

// Función para leer un número y convertirlo a double
read_number:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Inicializar resultado
    fmov d0, xzr
    
    // Leer dígitos antes del punto
read_digits:
    ldrb w0, [x22], #1
    cmp w0, #'.'
    b.eq read_decimal
    cmp w0, #','
    b.eq done_reading
    cmp w0, #'\n'
    b.eq done_reading
    
    sub w0, w0, #'0'
    scvtf d1, w0
    
    adr x0, const_ten
    ldr d2, [x0]
    fmul d0, d0, d2
    fadd d0, d0, d1
    b read_digits
    
read_decimal:
    adr x0, const_point_one
    ldr d2, [x0]           // d2 = 0.1
    
read_decimal_digits:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.eq done_reading
    cmp w0, #'\n'
    b.eq done_reading
    
    sub w0, w0, #'0'
    scvtf d1, w0
    fmul d1, d1, d2
    fadd d0, d0, d1
    fmul d2, d2, d2       // siguiente posición decimal
    b read_decimal_digits
    
done_reading:
    ldp x29, x30, [sp], #16
    ret
    
sort_array:
    // x0 = dirección del array a ordenar
    // x1 = número de elementos (5 en nuestro caso)
    stp x29, x30, [sp, -48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    
    mov x19, x0          // Guardar dirección base
    sub x20, x1, #1      // n-1 para el bucle externo
    
outer_loop:
    mov x21, xzr        // i = 0
    
inner_loop:
    cmp x21, x20
    b.ge outer_loop_end
    
    // Cargar elementos adyacentes
    lsl x22, x21, #3
    add x22, x19, x22
    ldr d0, [x22]
    ldr d1, [x22, #8]
    
    // Comparar
    fcmp d0, d1
    b.le no_swap
    
    // Intercambiar si d0 > d1
    str d1, [x22]
    str d0, [x22, #8]
    
no_swap:
    add x21, x21, #1
    b inner_loop
    
outer_loop_end:
    subs x20, x20, #1
    b.ne outer_loop
    
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

calculate_medians:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Copiar temp_interna
    mov x4, #40          // 5 elementos * 8 bytes
    adr x0, temp_interna_sorted
    adr x1, temp_interna
1:  // Etiqueta local
    ldr d0, [x1], #8
    str d0, [x0], #8
    subs x4, x4, #8
    b.ne 1b
    
    // Copiar temp_externa
    mov x4, #40
    adr x0, temp_externa_sorted
    adr x1, temp_externa
2:  // Etiqueta local
    ldr d0, [x1], #8
    str d0, [x0], #8
    subs x4, x4, #8
    b.ne 2b
    
    // Copiar nivel_agua
    mov x4, #40
    adr x0, nivel_agua_sorted
    adr x1, nivel_agua
3:  // Etiqueta local
    ldr d0, [x1], #8
    str d0, [x0], #8
    subs x4, x4, #8
    b.ne 3b
    
    // Ordenar cada array
    adr x0, temp_interna_sorted
    mov x1, #5
    bl sort_array
    
    adr x0, temp_externa_sorted
    mov x1, #5
    bl sort_array
    
    adr x0, nivel_agua_sorted
    mov x1, #5
    bl sort_array
    
    // Calcular medianas (elemento central para n=5)
    adr x0, temp_interna_sorted
    ldr d0, [x0, #16]    // Índice 2 (tercer elemento)
    adr x0, median_temp_int
    str d0, [x0]
    
    adr x0, temp_externa_sorted
    ldr d0, [x0, #16]
    adr x0, median_temp_ext
    str d0, [x0]
    
    adr x0, nivel_agua_sorted
    ldr d0, [x0, #16]
    adr x0, median_nivel
    str d0, [x0]
    
    ldp x29, x30, [sp], #16
    ret
    
copy_temp_int:
    ldr d0, [x1], #8
    str d0, [x0], #8
    subs x4, x4, #8
    b.ne copy_temp_int
    
    // Ordenar cada array
    adr x0, temp_interna_sorted
    mov x1, #5
    bl sort_array
    
    adr x0, temp_externa_sorted
    mov x1, #5
    bl sort_array
    
    adr x0, nivel_agua_sorted
    mov x1, #5
    bl sort_array
    
    // Calcular medianas (elemento central para n=5)
    adr x0, temp_interna_sorted
    ldr d0, [x0, #16]    // Índice 2 (tercer elemento)
    adr x0, median_temp_int
    str d0, [x0]
    
    adr x0, temp_externa_sorted
    ldr d0, [x0, #16]
    adr x0, median_temp_ext
    str d0, [x0]
    
    adr x0, nivel_agua_sorted
    ldr d0, [x0, #16]
    adr x0, median_nivel
    str d0, [x0]
    
    ldp x29, x30, [sp], #16
    ret

// Nueva función para escribir medianas a archivo
write_medians_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Crear archivo de medianas
    mov x0, #-100
    adr x1, outfile_median
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_median_error
    
    mov x19, x0           // Guardar fd
    
    // Truncar el archivo
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46
    svc #0
    
    // Escribir mediana temperatura interna
    mov x0, x19
    adr x1, msg_med_temp_int
    mov x2, msg_med_temp_int_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_med_temp_int
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir mediana temperatura externa
    mov x0, x19
    adr x1, msg_med_temp_ext
    mov x2, msg_med_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_med_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir mediana nivel de agua
    mov x0, x19
    adr x1, msg_med_nivel
    mov x2, msg_med_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_med_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Cerrar archivo
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_median_done

write_median_error:
    mov x0, #1

write_median_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

convert_medians_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Convertir mediana temperatura interna
    adr x0, median_temp_int
    ldr d0, [x0]
    adr x0, out_med_temp_int
    bl double_to_string
    
    // Convertir mediana temperatura externa
    adr x0, median_temp_ext
    ldr d0, [x0]
    adr x0, out_med_temp_ext
    bl double_to_string
    
    // Convertir mediana nivel de agua
    adr x0, median_nivel
    ldr d0, [x0]
    adr x0, out_med_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

do_analysis:
    // Guardar el registro de retorno
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Abrir archivo
    mov x0, #-100           // AT_FDCWD
    adr x1, filename
    mov x2, #0              // O_RDONLY
    mov x8, #56             // openat
    svc #0
    
    // Verificar error
    cmp x0, #0
    b.lt error_exit
    
    // Guardar file descriptor
    adr x1, fd
    str w0, [x1]
    
    // Leer archivo
    mov x0, x0              // Usar x0 directamente
    adr x1, buffer          // buffer
    mov x2, #2048          // tamaño
    mov x8, #63            // read
    svc #0
    
    // Verificar error
    cmp x0, #0
    b.le error_exit
    
    // Inicializar punteros a arrays
    adr x19, temp_interna
    adr x20, temp_externa
    adr x21, nivel_agua
    
    // Inicializar puntero al buffer
    adr x22, buffer
    mov x23, #0            // contador de líneas
    
    // Saltar primera línea (headers)
skip_header:
    ldrb w0, [x22], #1
    cmp w0, #'\n'
    b.ne skip_header
    
    // Procesar datos
process_data:
    cmp x23, #5            // máximo 5 líneas
    b.ge done_processing
    
    // Saltar fecha y hora (buscar primera coma)
skip_datetime:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.ne skip_datetime
    
    // Leer temperatura interna
    bl read_number
    str d0, [x19, x23, lsl #3]
    
    // Leer temperatura externa
    bl read_number
    str d0, [x20, x23, lsl #3]
    
    // Saltar "Estado del Suelo"
skip_soil:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.ne skip_soil
    
    // Leer nivel de agua
    bl read_number
    str d0, [x21, x23, lsl #3]
    
    // Buscar fin de línea
skip_rest:
    ldrb w0, [x22], #1
    cmp w0, #'\n'
    b.ne skip_rest
    
    add x23, x23, #1
    b process_data
    
done_processing:
    // Calcular promedios y medianas
    bl calculate_averages
    bl calculate_medians
    bl convert_to_text
    bl convert_medians_to_text
    bl calculate_maxmin
    bl convert_maxmin_to_text
    bl calculate_ranges
    bl convert_ranges_to_text
    bl calculate_modes
    bl convert_modes_to_text
    
    // Cerrar archivo de entrada
    adr x1, fd
    ldr w0, [x1]
    mov x8, #57            // close
    svc #0

    // Restaurar registros y volver al menú
    ldp x29, x30, [sp], #16
    b menu_loop

error_exit:
    mov x0, #1
    adr x1, msg_error
    mov x2, #20
    mov x8, #64            // write
    svc #0
    
    // Si hay error, también volvemos al menú
    ldp x29, x30, [sp], #16
    b menu_loop

calculate_maxmin:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Inicializar con el primer valor de cada array
    adr x0, temp_interna
    ldr d0, [x0]           // Primer valor como máximo y mínimo inicial
    adr x1, max_temp_int
    str d0, [x1]
    adr x1, min_temp_int
    str d0, [x1]
    
    adr x0, temp_externa
    ldr d0, [x0]
    adr x1, max_temp_ext
    str d0, [x1]
    adr x1, min_temp_ext
    str d0, [x1]
    
    adr x0, nivel_agua
    ldr d0, [x0]
    adr x1, max_nivel
    str d0, [x1]
    adr x1, min_nivel
    str d0, [x1]
    
    // Iterar sobre los arrays (índices 1-4)
    mov x4, #1              // Empezar desde el segundo elemento
maxmin_loop:
    cmp x4, #5
    b.ge maxmin_done
    
    // Temperatura interna
    adr x0, temp_interna
    lsl x1, x4, #3         // multiplicar índice por 8 (tamaño de double)
    add x0, x0, x1
    ldr d0, [x0]           // Cargar valor actual
    
    adr x1, max_temp_int
    ldr d1, [x1]
    fcmp d0, d1
    b.le check_min_temp_int
    str d0, [x1]           // Actualizar máximo
check_min_temp_int:
    adr x1, min_temp_int
    ldr d1, [x1]
    fcmp d0, d1
    b.ge check_temp_ext
    str d0, [x1]           // Actualizar mínimo
    
    // Temperatura externa
check_temp_ext:
    adr x0, temp_externa
    lsl x1, x4, #3
    add x0, x0, x1
    ldr d0, [x0]
    
    adr x1, max_temp_ext
    ldr d1, [x1]
    fcmp d0, d1
    b.le check_min_temp_ext
    str d0, [x1]
check_min_temp_ext:
    adr x1, min_temp_ext
    ldr d1, [x1]
    fcmp d0, d1
    b.ge check_nivel
    str d0, [x1]
    
    // Nivel de agua
check_nivel:
    adr x0, nivel_agua
    lsl x1, x4, #3
    add x0, x0, x1
    ldr d0, [x0]
    
    adr x1, max_nivel
    ldr d1, [x1]
    fcmp d0, d1
    b.le check_min_nivel
    str d0, [x1]
check_min_nivel:
    adr x1, min_nivel
    ldr d1, [x1]
    fcmp d0, d1
    b.ge continue_loop
    str d0, [x1]
    
continue_loop:
    add x4, x4, #1
    b maxmin_loop
    
maxmin_done:
    ldp x29, x30, [sp], #16
    ret

// Función para convertir máximos y mínimos a texto
convert_maxmin_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Convertir máximos
    adr x0, max_temp_int
    ldr d0, [x0]
    adr x0, out_max_temp_int
    bl double_to_string
    
    adr x0, max_temp_ext
    ldr d0, [x0]
    adr x0, out_max_temp_ext
    bl double_to_string
    
    adr x0, max_nivel
    ldr d0, [x0]
    adr x0, out_max_nivel
    bl double_to_string
    
    // Convertir mínimos
    adr x0, min_temp_int
    ldr d0, [x0]
    adr x0, out_min_temp_int
    bl double_to_string
    
    adr x0, min_temp_ext
    ldr d0, [x0]
    adr x0, out_min_temp_ext
    bl double_to_string
    
    adr x0, min_nivel
    ldr d0, [x0]
    adr x0, out_min_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

// Función para escribir máximos y mínimos a archivo
write_maxmin_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Crear archivo
    mov x0, #-100
    adr x1, outfile_maxmin
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_maxmin_error
    
    mov x19, x0           // Guardar fd
    
    // Truncar el archivo
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46
    svc #0
    
    // Escribir máximos y mínimos
    // Temperatura interna
    mov x0, x19
    adr x1, msg_max_temp_int
    mov x2, msg_max_temp_int_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_max_temp_int
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, msg_min_temp_int
    mov x2, msg_min_temp_int_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_min_temp_int
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Temperatura externa
    mov x0, x19
    adr x1, msg_max_temp_ext
    mov x2, msg_max_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_max_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, msg_min_temp_ext
    mov x2, msg_min_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_min_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Nivel de agua
    mov x0, x19
    adr x1, msg_max_nivel
    mov x2, msg_max_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_max_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, msg_min_nivel
    mov x2, msg_min_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_min_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Cerrar archivo
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_maxmin_done

write_maxmin_error:
    mov x0, #1

write_maxmin_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

calculate_ranges:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Calcular rango temperatura interna
    adr x0, max_temp_int
    ldr d0, [x0]
    adr x0, min_temp_int
    ldr d1, [x0]
    fsub d0, d0, d1
    adr x0, range_temp_int
    str d0, [x0]
    
    // Calcular rango temperatura externa
    adr x0, max_temp_ext
    ldr d0, [x0]
    adr x0, min_temp_ext
    ldr d1, [x0]
    fsub d0, d0, d1
    adr x0, range_temp_ext
    str d0, [x0]
    
    // Calcular rango nivel de agua
    adr x0, max_nivel
    ldr d0, [x0]
    adr x0, min_nivel
    ldr d1, [x0]
    fsub d0, d0, d1
    adr x0, range_nivel
    str d0, [x0]
    
    ldp x29, x30, [sp], #16
    ret

// Función para convertir rangos a texto
convert_ranges_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Convertir rango temperatura interna
    adr x0, range_temp_int
    ldr d0, [x0]
    adr x0, out_range_temp_int
    bl double_to_string
    
    // Convertir rango temperatura externa
    adr x0, range_temp_ext
    ldr d0, [x0]
    adr x0, out_range_temp_ext
    bl double_to_string
    
    // Convertir rango nivel de agua
    adr x0, range_nivel
    ldr d0, [x0]
    adr x0, out_range_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

// Función para escribir rangos a archivo
write_ranges_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Crear archivo
    mov x0, #-100
    adr x1, outfile_range
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_range_error
    
    mov x19, x0           // Guardar fd
    
    // Truncar el archivo
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46
    svc #0
    
    // Escribir rango temperatura interna
    mov x0, x19
    adr x1, msg_range_temp_int
    mov x2, msg_range_temp_int_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_range_temp_int
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir rango temperatura externa
    mov x0, x19
    adr x1, msg_range_temp_ext
    mov x2, msg_range_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_range_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir rango nivel de agua
    mov x0, x19
    adr x1, msg_range_nivel
    mov x2, msg_range_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_range_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Cerrar archivo
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_range_done

write_range_error:
    mov x0, #1

write_range_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

calculate_modes:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Calculate mode for each array
    adr x0, temp_interna
    adr x1, mode_temp_int
    bl find_mode
    
    adr x0, temp_externa
    adr x1, mode_temp_ext
    bl find_mode
    
    adr x0, nivel_agua
    adr x1, mode_nivel
    bl find_mode
    
    ldp x29, x30, [sp], #16
    ret

find_mode:
    // x0 = array address, x1 = result address
    stp x29, x30, [sp, -48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    
    mov x19, x0          // array address
    mov x20, x1          // result address
    fmov d6, xzr         // current mode
    mov w21, #0          // max frequency
    
    mov x4, #0          // outer loop counter
outer_mode_loop:
    cmp x4, #5
    b.ge end_mode_calc
    
    mov w22, #0          // current frequency
    ldr d0, [x19, x4, lsl #3]  // current value
    
    mov x5, #0          // inner loop counter
inner_mode_loop:
    cmp x5, #5
    b.ge check_frequency
    
    ldr d1, [x19, x5, lsl #3]
    fcmp d0, d1
    b.ne continue_inner
    add w22, w22, #1
    
continue_inner:
    add x5, x5, #1
    b inner_mode_loop
    
check_frequency:
    cmp w22, w21
    b.le continue_outer
    mov w21, w22
    fmov d6, d0
    
continue_outer:
    add x4, x4, #1
    b outer_mode_loop
    
end_mode_calc:
    str d6, [x20]
    
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

convert_modes_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    adr x0, mode_temp_int
    ldr d0, [x0]
    adr x0, out_mode_temp_int
    bl double_to_string
    
    adr x0, mode_temp_ext
    ldr d0, [x0]
    adr x0, out_mode_temp_ext
    bl double_to_string
    
    adr x0, mode_nivel
    ldr d0, [x0]
    adr x0, out_mode_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

write_modes_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    mov x0, #-100
    adr x1, outfile_mode
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_mode_error
    mov x19, x0
    
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46
    svc #0
    
    mov x0, x19
    adr x1, msg_mode_temp_int
    mov x2, msg_mode_temp_int_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_mode_temp_int
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, msg_mode_temp_ext
    mov x2, msg_mode_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_mode_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, msg_mode_nivel
    mov x2, msg_mode_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_mode_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_mode_done

write_mode_error:
    mov x0, #1

write_mode_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret